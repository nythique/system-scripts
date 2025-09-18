#!/bin/bash
#
# Script: monitor-disk-space.sh
# Auteur: Nythique
# Date: 2025-06-17
# Version: 1.0.0
# Description: Surveille l'espace disque et envoie des alertes si nécessaire
#
# Usage: ./monitor-disk-space.sh [options] [mount_point]
# Options:
#   -h, --help     Afficher l'aide
#   -v, --version  Afficher la version
#   -t, --threshold  Seuil d'alerte en pourcentage (défaut: 80)
#   -e, --email    Adresse email pour les alertes
#   -c, --critical Seuil critique en pourcentage (défaut: 90)
#
# Exemples:
#   ./monitor-disk-space.sh
#   ./monitor-disk-space.sh -t 85 -e admin@example.com
#   ./monitor-disk-space.sh /home

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "$0")"
VERSION="1.0.0"
DEFAULT_THRESHOLD=80
DEFAULT_CRITICAL=90
LOG_FILE="/var/log/disk-monitor.log"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables globales
THRESHOLD=$DEFAULT_THRESHOLD
CRITICAL_THRESHOLD=$DEFAULT_CRITICAL
EMAIL_ADDRESS=""
MOUNT_POINT=""
VERBOSE=false

# Fonctions utilitaires
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $1" >> "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [WARN] $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $1" >> "$LOG_FILE"
}

log_debug() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[DEBUG]${NC} $1"
    fi
}

# Fonction d'aide
show_help() {
    cat << EOF
Usage: $SCRIPT_NAME [options] [mount_point]

Description: Surveille l'espace disque et envoie des alertes si nécessaire

Options:
    -h, --help           Afficher cette aide
    -v, --version        Afficher la version
    -t, --threshold N    Seuil d'alerte en pourcentage (défaut: $DEFAULT_THRESHOLD%)
    -c, --critical N     Seuil critique en pourcentage (défaut: $DEFAULT_CRITICAL%)
    -e, --email ADDR     Adresse email pour les alertes
    -d, --debug          Mode debug
    -l, --log FILE       Fichier de log (défaut: $LOG_FILE)

Arguments:
    mount_point          Point de montage à surveiller (optionnel, surveille tous si non spécifié)

Exemples:
    $SCRIPT_NAME
    $SCRIPT_NAME -t 85 -e admin@example.com
    $SCRIPT_NAME /home
    $SCRIPT_NAME -t 90 -c 95 -e admin@example.com /var

EOF
}

# Fonction pour vérifier les prérequis
check_prerequisites() {
    log_debug "Vérification des prérequis..."
    
    # Vérifier que df est disponible
    if ! command -v df >/dev/null 2>&1; then
        log_error "La commande 'df' n'est pas disponible"
        exit 1
    fi
    
    # Vérifier que awk est disponible
    if ! command -v awk >/dev/null 2>&1; then
        log_error "La commande 'awk' n'est pas disponible"
        exit 1
    fi
    
    # Créer le fichier de log si nécessaire
    touch "$LOG_FILE" 2>/dev/null || {
        log_warn "Impossible de créer le fichier de log $LOG_FILE"
        LOG_FILE="/tmp/disk-monitor.log"
        touch "$LOG_FILE"
    }
    
    log_debug "Prérequis vérifiés avec succès"
}

# Fonction pour obtenir l'utilisation du disque
get_disk_usage() {
    local mount_point="$1"
    local df_output
    
    if [[ -n "$mount_point" ]]; then
        # Vérifier si le point de montage existe
        if ! mountpoint -q "$mount_point" 2>/dev/null; then
            log_error "Le point de montage '$mount_point' n'existe pas ou n'est pas monté"
            return 1
        fi
        df_output=$(df -h "$mount_point" 2>/dev/null | tail -n 1)
    else
        # Obtenir tous les systèmes de fichiers
        df_output=$(df -h 2>/dev/null | grep -E '^/dev/' | grep -v '^/dev/loop')
    fi
    
    echo "$df_output"
}

# Fonction pour analyser l'utilisation
analyze_usage() {
    local df_output="$1"
    local mount_point="$2"
    local filesystem
    local size
    local used
    local available
    local use_percent
    local status="OK"
    local message=""
    
    # Parser la sortie de df
    if [[ -n "$mount_point" ]]; then
        read -r filesystem size used available use_percent mount <<< "$df_output"
    else
        while IFS= read -r line; do
            read -r filesystem size used available use_percent mount <<< "$line"
            
            # Extraire le pourcentage (enlever le %)
            use_percent=${use_percent%\%}
            
            # Vérifier les seuils
            if [[ "$use_percent" -ge "$CRITICAL_THRESHOLD" ]]; then
                status="CRITICAL"
                message="CRITIQUE: $mount ($filesystem) utilise ${use_percent}% de l'espace disque"
                log_error "$message"
                [[ -n "$EMAIL_ADDRESS" ]] && send_email_alert "$message" "CRITICAL"
            elif [[ "$use_percent" -ge "$THRESHOLD" ]]; then
                status="WARNING"
                message="ATTENTION: $mount ($filesystem) utilise ${use_percent}% de l'espace disque"
                log_warn "$message"
                [[ -n "$EMAIL_ADDRESS" ]] && send_email_alert "$message" "WARNING"
            else
                status="OK"
                message="OK: $mount ($filesystem) utilise ${use_percent}% de l'espace disque"
                log_info "$message"
            fi
            
            # Afficher les détails
            printf "%-20s %-10s %-10s %-10s %-8s %-8s %s\n" \
                   "$filesystem" "$size" "$used" "$available" "${use_percent}%" "$status" "$mount"
        done <<< "$df_output"
        return
    fi
    
    # Pour un point de montage spécifique
    use_percent=${use_percent%\%}
    
    if [[ "$use_percent" -ge "$CRITICAL_THRESHOLD" ]]; then
        status="CRITICAL"
        message="CRITIQUE: $mount_point ($filesystem) utilise ${use_percent}% de l'espace disque"
        log_error "$message"
        [[ -n "$EMAIL_ADDRESS" ]] && send_email_alert "$message" "CRITICAL"
    elif [[ "$use_percent" -ge "$THRESHOLD" ]]; then
        status="WARNING"
        message="ATTENTION: $mount_point ($filesystem) utilise ${use_percent}% de l'espace disque"
        log_warn "$message"
        [[ -n "$EMAIL_ADDRESS" ]] && send_email_alert "$message" "WARNING"
    else
        status="OK"
        message="OK: $mount_point ($filesystem) utilise ${use_percent}% de l'espace disque"
        log_info "$message"
    fi
    
    printf "%-20s %-10s %-10s %-10s %-8s %-8s %s\n" \
           "$filesystem" "$size" "$used" "$available" "${use_percent}%" "$status" "$mount_point"
}

# Fonction pour envoyer des alertes par email
send_email_alert() {
    local message="$1"
    local level="$2"
    local subject="[DISK MONITOR] $level - Alerte espace disque"
    local body="
Alerte d'espace disque détectée

$message

Date: $(date)
Hôte: $(hostname)
Seuils configurés:
- Seuil d'alerte: ${THRESHOLD}%
- Seuil critique: ${CRITICAL_THRESHOLD}%

Ce message a été généré automatiquement par le script de surveillance d'espace disque.
"
    
    if command -v mail >/dev/null 2>&1; then
        echo "$body" | mail -s "$subject" "$EMAIL_ADDRESS" 2>/dev/null && {
            log_info "Alerte email envoyée à $EMAIL_ADDRESS"
        } || {
            log_warn "Impossible d'envoyer l'email d'alerte"
        }
    else
        log_warn "La commande 'mail' n'est pas disponible, impossible d'envoyer l'alerte email"
    fi
}

# Fonction pour afficher un résumé
show_summary() {
    local total_fs
    local critical_count=0
    local warning_count=0
    local ok_count=0
    
    total_fs=$(df -h 2>/dev/null | grep -E '^/dev/' | grep -v '^/dev/loop' | wc -l)
    
    # Compter les différents états
    while IFS= read -r line; do
        read -r filesystem size used available use_percent mount <<< "$line"
        use_percent=${use_percent%\%}
        
        if [[ "$use_percent" -ge "$CRITICAL_THRESHOLD" ]]; then
            ((critical_count++))
        elif [[ "$use_percent" -ge "$THRESHOLD" ]]; then
            ((warning_count++))
        else
            ((ok_count++))
        fi
    done < <(df -h 2>/dev/null | grep -E '^/dev/' | grep -v '^/dev/loop')
    
    echo
    echo "=== RÉSUMÉ ==="
    echo "Total systèmes de fichiers: $total_fs"
    echo "OK: $ok_count"
    echo "ATTENTION: $warning_count"
    echo "CRITIQUE: $critical_count"
    echo "Seuils: Alerte=${THRESHOLD}%, Critique=${CRITICAL_THRESHOLD}%"
}

# Fonction principale
main() {
    local df_output
    
    # Traitement des arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                echo "$SCRIPT_NAME version $VERSION"
                exit 0
                ;;
            -t|--threshold)
                THRESHOLD="$2"
                shift 2
                ;;
            -c|--critical)
                CRITICAL_THRESHOLD="$2"
                shift 2
                ;;
            -e|--email)
                EMAIL_ADDRESS="$2"
                shift 2
                ;;
            -d|--debug)
                VERBOSE=true
                shift
                ;;
            -l|--log)
                LOG_FILE="$2"
                shift 2
                ;;
            -*)
                log_error "Option inconnue: $1"
                show_help
                exit 1
                ;;
            *)
                if [[ -z "$MOUNT_POINT" ]]; then
                    MOUNT_POINT="$1"
                else
                    log_error "Trop d'arguments: $1"
                    show_help
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validation des paramètres
    if ! [[ "$THRESHOLD" =~ ^[0-9]+$ ]] || [[ "$THRESHOLD" -lt 1 ]] || [[ "$THRESHOLD" -gt 100 ]]; then
        log_error "Le seuil doit être un nombre entre 1 et 100"
        exit 1
    fi
    
    if ! [[ "$CRITICAL_THRESHOLD" =~ ^[0-9]+$ ]] || [[ "$CRITICAL_THRESHOLD" -lt 1 ]] || [[ "$CRITICAL_THRESHOLD" -gt 100 ]]; then
        log_error "Le seuil critique doit être un nombre entre 1 et 100"
        exit 1
    fi
    
    if [[ "$THRESHOLD" -ge "$CRITICAL_THRESHOLD" ]]; then
        log_error "Le seuil d'alerte doit être inférieur au seuil critique"
        exit 1
    fi
    
    # Vérifier les prérequis
    check_prerequisites
    
    # Log du démarrage
    log_info "Démarrage de la surveillance d'espace disque"
    log_debug "Seuil d'alerte: ${THRESHOLD}%"
    log_debug "Seuil critique: ${CRITICAL_THRESHOLD}%"
    log_debug "Point de montage: ${MOUNT_POINT:-'tous'}"
    log_debug "Email: ${EMAIL_ADDRESS:-'aucun'}"
    
    # Afficher l'en-tête
    echo "=== SURVEILLANCE ESPACE DISQUE ==="
    echo "Date: $(date)"
    echo "Hôte: $(hostname)"
    echo
    printf "%-20s %-10s %-10s %-10s %-8s %-8s %s\n" \
           "FICHIER" "TAILLE" "UTILISÉ" "DISPONIBLE" "UTIL%" "STATUT" "MONTÉ SUR"
    echo "--------------------------------------------------------------------------------"
    
    # Obtenir et analyser l'utilisation du disque
    df_output=$(get_disk_usage "$MOUNT_POINT")
    if [[ $? -eq 0 ]]; then
        analyze_usage "$df_output" "$MOUNT_POINT"
        
        # Afficher le résumé si on surveille tous les systèmes de fichiers
        if [[ -z "$MOUNT_POINT" ]]; then
            show_summary
        fi
    else
        log_error "Impossible d'obtenir les informations d'espace disque"
        exit 1
    fi
    
    log_info "Surveillance terminée"
}

# Point d'entrée
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi