#!/bin/bash
#
# Script: update-system.sh
# Auteur: Nythique
# Date: 2025-06-17
# Version: 1.0.0
# Description: Mise à jour automatique du système selon la distribution
#
# Usage: ./update-system.sh [options]
# Options:
#   -h, --help     Afficher l'aide
#   -v, --version  Afficher la version
#   -c, --check    Vérifier les mises à jour disponibles sans les installer
#   -f, --force    Forcer la mise à jour sans demander confirmation
#   -s, --security Mettre à jour uniquement les paquets de sécurité
#   -d, --dry-run  Simulation sans effectuer les mises à jour
#   -l, --log      Fichier de log personnalisé
#
# Exemples:
#   ./update-system.sh
#   ./update-system.sh --check
#   ./update-system.sh --security --force
#   ./update-system.sh --dry-run

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "$0")"
VERSION="1.0.0"
DEFAULT_LOG_FILE="/var/log/system-update.log"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Variables globales
CHECK_ONLY=false
FORCE_UPDATE=false
SECURITY_ONLY=false
DRY_RUN=false
LOG_FILE="$DEFAULT_LOG_FILE"
DISTRO=""
PACKAGE_MANAGER=""
UPDATE_CMD=""
UPGRADE_CMD=""
CLEAN_CMD=""

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
    echo -e "${BLUE}[DEBUG]${NC} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [DEBUG] $1" >> "$LOG_FILE"
}

# Fonction d'aide
show_help() {
    cat << EOF
Usage: $SCRIPT_NAME [options]

Description: Mise à jour automatique du système selon la distribution détectée

Options:
    -h, --help           Afficher cette aide
    -v, --version        Afficher la version
    -c, --check          Vérifier les mises à jour disponibles sans les installer
    -f, --force          Forcer la mise à jour sans demander confirmation
    -s, --security       Mettre à jour uniquement les paquets de sécurité
    -d, --dry-run        Simulation sans effectuer les mises à jour
    -l, --log FILE       Fichier de log personnalisé (défaut: $DEFAULT_LOG_FILE)

Distributions supportées:
    - Ubuntu/Debian (apt)
    - CentOS/RHEL/Fedora (yum/dnf)
    - Arch Linux (pacman)
    - Alpine Linux (apk)
    - openSUSE (zypper)

Exemples:
    $SCRIPT_NAME
    $SCRIPT_NAME --check
    $SCRIPT_NAME --security --force
    $SCRIPT_NAME --dry-run --log /tmp/update.log

EOF
}

# Fonction pour détecter la distribution
detect_distribution() {
    log_debug "Détection de la distribution..."
    
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        DISTRO="$ID"
        log_debug "Distribution détectée: $DISTRO ($VERSION)"
    elif [[ -f /etc/redhat-release ]]; then
        DISTRO="rhel"
        log_debug "Distribution détectée: RHEL/CentOS"
    elif [[ -f /etc/debian_version ]]; then
        DISTRO="debian"
        log_debug "Distribution détectée: Debian"
    else
        log_error "Impossible de détecter la distribution"
        exit 1
    fi
    
    # Configurer le gestionnaire de paquets selon la distribution
    case "$DISTRO" in
        "ubuntu"|"debian")
            PACKAGE_MANAGER="apt"
            UPDATE_CMD="apt update"
            UPGRADE_CMD="apt upgrade -y"
            CLEAN_CMD="apt autoremove -y && apt autoclean"
            ;;
        "centos"|"rhel"|"fedora"|"rocky"|"alma")
            if command -v dnf >/dev/null 2>&1; then
                PACKAGE_MANAGER="dnf"
                UPDATE_CMD="dnf check-update"
                UPGRADE_CMD="dnf update -y"
                CLEAN_CMD="dnf autoremove -y"
            else
                PACKAGE_MANAGER="yum"
                UPDATE_CMD="yum check-update"
                UPGRADE_CMD="yum update -y"
                CLEAN_CMD="yum autoremove -y"
            fi
            ;;
        "arch")
            PACKAGE_MANAGER="pacman"
            UPDATE_CMD="pacman -Sy"
            UPGRADE_CMD="pacman -Syu --noconfirm"
            CLEAN_CMD="pacman -Rns \$(pacman -Qtdq) 2>/dev/null || true"
            ;;
        "alpine")
            PACKAGE_MANAGER="apk"
            UPDATE_CMD="apk update"
            UPGRADE_CMD="apk upgrade"
            CLEAN_CMD="apk cache clean"
            ;;
        "opensuse"|"sles")
            PACKAGE_MANAGER="zypper"
            UPDATE_CMD="zypper refresh"
            UPGRADE_CMD="zypper update -y"
            CLEAN_CMD="zypper clean"
            ;;
        *)
            log_error "Distribution non supportée: $DISTRO"
            exit 1
            ;;
    esac
    
    log_info "Gestionnaire de paquets: $PACKAGE_MANAGER"
}

# Fonction pour vérifier les prérequis
check_prerequisites() {
    log_debug "Vérification des prérequis..."
    
    # Vérifier les droits root
    if [[ $EUID -ne 0 ]]; then
        log_error "Ce script nécessite des droits root"
        exit 1
    fi
    
    # Vérifier que le gestionnaire de paquets est disponible
    if ! command -v "$PACKAGE_MANAGER" >/dev/null 2>&1; then
        log_error "Le gestionnaire de paquets '$PACKAGE_MANAGER' n'est pas disponible"
        exit 1
    fi
    
    # Créer le fichier de log si nécessaire
    touch "$LOG_FILE" 2>/dev/null || {
        log_warn "Impossible de créer le fichier de log $LOG_FILE"
        LOG_FILE="/tmp/system-update.log"
        touch "$LOG_FILE"
    }
    
    log_debug "Prérequis vérifiés avec succès"
}

# Fonction pour vérifier les mises à jour disponibles
check_updates() {
    log_info "Vérification des mises à jour disponibles..."
    
    case "$PACKAGE_MANAGER" in
        "apt")
            if $DRY_RUN; then
                log_info "Simulation: apt update"
            else
                apt update >/dev/null 2>&1
            fi
            
            if $DRY_RUN; then
                log_info "Simulation: apt list --upgradable"
                available_updates=$(apt list --upgradable 2>/dev/null | grep -v "WARNING" | wc -l)
            else
                available_updates=$(apt list --upgradable 2>/dev/null | grep -v "WARNING" | wc -l)
            fi
            ;;
        "dnf")
            if $DRY_RUN; then
                log_info "Simulation: dnf check-update"
                available_updates=$(dnf check-update 2>/dev/null | grep -v "^$" | wc -l)
            else
                available_updates=$(dnf check-update 2>/dev/null | grep -v "^$" | wc -l)
            fi
            ;;
        "yum")
            if $DRY_RUN; then
                log_info "Simulation: yum check-update"
                available_updates=$(yum check-update 2>/dev/null | grep -v "^$" | wc -l)
            else
                available_updates=$(yum check-update 2>/dev/null | grep -v "^$" | wc -l)
            fi
            ;;
        "pacman")
            if $DRY_RUN; then
                log_info "Simulation: pacman -Qu"
                available_updates=$(pacman -Qu 2>/dev/null | wc -l)
            else
                available_updates=$(pacman -Qu 2>/dev/null | wc -l)
            fi
            ;;
        "apk")
            if $DRY_RUN; then
                log_info "Simulation: apk version"
                available_updates=$(apk version 2>/dev/null | grep -c "UPD" || echo "0")
            else
                available_updates=$(apk version 2>/dev/null | grep -c "UPD" || echo "0")
            fi
            ;;
        "zypper")
            if $DRY_RUN; then
                log_info "Simulation: zypper list-updates"
                available_updates=$(zypper list-updates 2>/dev/null | grep -c "v |" || echo "0")
            else
                available_updates=$(zypper list-updates 2>/dev/null | grep -c "v |" || echo "0")
            fi
            ;;
    esac
    
    if [[ "$available_updates" -gt 0 ]]; then
        log_info "Mises à jour disponibles: $available_updates paquets"
        
        # Afficher la liste des paquets à mettre à jour
        case "$PACKAGE_MANAGER" in
            "apt")
                if ! $DRY_RUN; then
                    echo "Paquets à mettre à jour:"
                    apt list --upgradable 2>/dev/null | grep -v "WARNING" | head -10
                    if [[ $(apt list --upgradable 2>/dev/null | grep -v "WARNING" | wc -l) -gt 10 ]]; then
                        echo "... et $(($(apt list --upgradable 2>/dev/null | grep -v "WARNING" | wc -l) - 10)) autres"
                    fi
                fi
                ;;
            "dnf"|"yum")
                if ! $DRY_RUN; then
                    echo "Paquets à mettre à jour:"
                    $PACKAGE_MANAGER check-update 2>/dev/null | grep -v "^$" | head -10
                    if [[ $($PACKAGE_MANAGER check-update 2>/dev/null | grep -v "^$" | wc -l) -gt 10 ]]; then
                        echo "... et $(($($PACKAGE_MANAGER check-update 2>/dev/null | grep -v "^$" | wc -l) - 10)) autres"
                    fi
                fi
                ;;
            "pacman")
                if ! $DRY_RUN; then
                    echo "Paquets à mettre à jour:"
                    pacman -Qu 2>/dev/null | head -10
                    if [[ $(pacman -Qu 2>/dev/null | wc -l) -gt 10 ]]; then
                        echo "... et $(($(pacman -Qu 2>/dev/null | wc -l) - 10)) autres"
                    fi
                fi
                ;;
        esac
    else
        log_info "Aucune mise à jour disponible"
    fi
    
    return $available_updates
}

# Fonction pour effectuer les mises à jour de sécurité
update_security() {
    log_info "Mise à jour des paquets de sécurité..."
    
    case "$PACKAGE_MANAGER" in
        "apt")
            if $DRY_RUN; then
                log_info "Simulation: unattended-upgrades --dry-run"
            else
                if command -v unattended-upgrades >/dev/null 2>&1; then
                    unattended-upgrades --dry-run
                    log_info "Mises à jour de sécurité configurées via unattended-upgrades"
                else
                    log_warn "unattended-upgrades non disponible, mise à jour complète recommandée"
                    return 1
                fi
            fi
            ;;
        "dnf")
            if $DRY_RUN; then
                log_info "Simulation: dnf update --security"
            else
                dnf update --security -y
            fi
            ;;
        "yum")
            if $DRY_RUN; then
                log_info "Simulation: yum update --security"
            else
                yum update --security -y
            fi
            ;;
        "pacman")
            log_warn "Pacman ne distingue pas les mises à jour de sécurité"
            return 1
            ;;
        "apk")
            if $DRY_RUN; then
                log_info "Simulation: apk upgrade"
            else
                apk upgrade
            fi
            ;;
        "zypper")
            if $DRY_RUN; then
                log_info "Simulation: zypper patch"
            else
                zypper patch -y
            fi
            ;;
    esac
}

# Fonction pour effectuer les mises à jour complètes
update_system() {
    log_info "Mise à jour complète du système..."
    
    case "$PACKAGE_MANAGER" in
        "apt")
            if $DRY_RUN; then
                log_info "Simulation: apt update && apt upgrade"
            else
                apt update
                apt upgrade -y
            fi
            ;;
        "dnf")
            if $DRY_RUN; then
                log_info "Simulation: dnf update"
            else
                dnf update -y
            fi
            ;;
        "yum")
            if $DRY_RUN; then
                log_info "Simulation: yum update"
            else
                yum update -y
            fi
            ;;
        "pacman")
            if $DRY_RUN; then
                log_info "Simulation: pacman -Syu"
            else
                pacman -Syu --noconfirm
            fi
            ;;
        "apk")
            if $DRY_RUN; then
                log_info "Simulation: apk update && apk upgrade"
            else
                apk update
                apk upgrade
            fi
            ;;
        "zypper")
            if $DRY_RUN; then
                log_info "Simulation: zypper update"
            else
                zypper update -y
            fi
            ;;
    esac
}

# Fonction pour nettoyer le cache
clean_cache() {
    log_info "Nettoyage du cache des paquets..."
    
    case "$PACKAGE_MANAGER" in
        "apt")
            if $DRY_RUN; then
                log_info "Simulation: apt autoremove && apt autoclean"
            else
                apt autoremove -y
                apt autoclean
            fi
            ;;
        "dnf")
            if $DRY_RUN; then
                log_info "Simulation: dnf autoremove"
            else
                dnf autoremove -y
            fi
            ;;
        "yum")
            if $DRY_RUN; then
                log_info "Simulation: yum autoremove"
            else
                yum autoremove -y
            fi
            ;;
        "pacman")
            if $DRY_RUN; then
                log_info "Simulation: pacman -Rns (paquets orphelins)"
            else
                pacman -Rns $(pacman -Qtdq) 2>/dev/null || true
            fi
            ;;
        "apk")
            if $DRY_RUN; then
                log_info "Simulation: apk cache clean"
            else
                apk cache clean
            fi
            ;;
        "zypper")
            if $DRY_RUN; then
                log_info "Simulation: zypper clean"
            else
                zypper clean
            fi
            ;;
    esac
}

# Fonction pour afficher un résumé
show_summary() {
    local end_time
    local duration
    
    end_time=$(date)
    duration=$(( $(date +%s) - $(date -d "$start_time" +%s) ))
    
    echo
    echo "=== RÉSUMÉ DE LA MISE À JOUR ==="
    echo "Distribution: $DISTRO"
    echo "Gestionnaire: $PACKAGE_MANAGER"
    echo "Début: $start_time"
    echo "Fin: $end_time"
    echo "Durée: ${duration} secondes"
    echo "Mode: $($DRY_RUN && echo "Simulation" || echo "Réel")"
    echo "Type: $($SECURITY_ONLY && echo "Sécurité uniquement" || echo "Complet")"
    echo "Fichier de log: $LOG_FILE"
}

# Fonction principale
main() {
    local start_time
    local available_updates
    
    start_time=$(date)
    
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
            -c|--check)
                CHECK_ONLY=true
                shift
                ;;
            -f|--force)
                FORCE_UPDATE=true
                shift
                ;;
            -s|--security)
                SECURITY_ONLY=true
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=true
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
                log_error "Argument inattendu: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Détecter la distribution
    detect_distribution
    
    # Vérifier les prérequis
    check_prerequisites
    
    # Log du démarrage
    log_info "Démarrage de la mise à jour système"
    log_debug "Distribution: $DISTRO"
    log_debug "Gestionnaire: $PACKAGE_MANAGER"
    log_debug "Mode check: $CHECK_ONLY"
    log_debug "Mode force: $FORCE_UPDATE"
    log_debug "Mode sécurité: $SECURITY_ONLY"
    log_debug "Mode simulation: $DRY_RUN"
    
    # Vérifier les mises à jour disponibles
    check_updates
    available_updates=$?
    
    # Si mode check uniquement, s'arrêter ici
    if $CHECK_ONLY; then
        log_info "Mode vérification uniquement - aucune mise à jour effectuée"
        exit 0
    fi
    
    # Si aucune mise à jour disponible, s'arrêter
    if [[ $available_updates -eq 0 ]]; then
        log_info "Aucune mise à jour nécessaire"
        exit 0
    fi
    
    # Demander confirmation sauf si --force ou --dry-run
    if ! $FORCE_UPDATE && ! $DRY_RUN; then
        echo
        echo "Mises à jour disponibles: $available_updates paquets"
        echo "Type de mise à jour: $($SECURITY_ONLY && echo "Sécurité uniquement" || echo "Complète")"
        echo
        read -p "Continuer la mise à jour? (o/N): " -r
        if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
            log_info "Mise à jour annulée par l'utilisateur"
            exit 0
        fi
    fi
    
    # Effectuer les mises à jour
    if $SECURITY_ONLY; then
        update_security
    else
        update_system
    fi
    
    # Nettoyer le cache
    clean_cache
    
    # Afficher le résumé
    show_summary
    
    log_info "Mise à jour terminée avec succès"
}

# Point d'entrée
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi