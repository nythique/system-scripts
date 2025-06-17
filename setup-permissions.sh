#!/bin/bash
#
# Script: setup-permissions.sh
# Auteur: Nythique
# Date: 2025-06-17
# Version: 1.0.0
# Description: Configure les permissions d'exécution pour tous les scripts
#
# Usage: ./setup-permissions.sh [options]
# Options:
#   -h, --help     Afficher l'aide
#   -v, --version  Afficher la version
#   -d, --dry-run  Simulation sans modifier les permissions
#   -f, --force    Forcer la modification sans demander confirmation
#
# Exemples:
#   ./setup-permissions.sh
#   ./setup-permissions.sh --dry-run
#   ./setup-permissions.sh --force

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "$0")"
VERSION="1.0.0"
DRY_RUN=false
FORCE=false

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Statistiques
TOTAL_SCRIPTS=0
MODIFIED_SCRIPTS=0
SKIPPED_SCRIPTS=0

# Fonctions utilitaires
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# Fonction d'aide
show_help() {
    cat << EOF
Usage: $SCRIPT_NAME [options]

Description: Configure les permissions d'exécution pour tous les scripts du projet

Options:
    -h, --help           Afficher cette aide
    -v, --version        Afficher la version
    -d, --dry-run        Simulation sans modifier les permissions
    -f, --force          Forcer la modification sans demander confirmation

Types de scripts traités:
    - Scripts Bash (.sh)
    - Scripts PowerShell (.ps1)
    - Scripts Batch (.bat)

Exemples:
    $SCRIPT_NAME
    $SCRIPT_NAME --dry-run
    $SCRIPT_NAME --force

EOF
}

# Fonction pour modifier les permissions d'un fichier
set_executable_permission() {
    local file_path="$1"
    local file_name="$(basename "$file_path")"
    
    if [[ ! -f "$file_path" ]]; then
        log_warn "Fichier non trouvé: $file_path"
        return 1
    fi
    
    # Vérifier si le fichier est déjà exécutable
    if [[ -x "$file_path" ]]; then
        log_debug "Déjà exécutable: $file_name"
        ((SKIPPED_SCRIPTS++))
        return 0
    fi
    
    # Modifier les permissions
    if $DRY_RUN; then
        log_info "SIMULATION: chmod +x $file_path"
    else
        if chmod +x "$file_path" 2>/dev/null; then
            log_info "Permissions modifiées: $file_name"
            ((MODIFIED_SCRIPTS++))
        else
            log_error "Impossible de modifier les permissions: $file_name"
            return 1
        fi
    fi
    
    return 0
}

# Fonction pour traiter un répertoire
process_directory() {
    local dir_path="$1"
    local pattern="$2"
    
    log_debug "Traitement du répertoire: $dir_path"
    
    if [[ ! -d "$dir_path" ]]; then
        log_warn "Répertoire non trouvé: $dir_path"
        return 1
    fi
    
    # Trouver tous les fichiers correspondant au pattern
    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]]; then
            set_executable_permission "$file"
            ((TOTAL_SCRIPTS++))
        fi
    done < <(find "$dir_path" -type f -name "$pattern" -print0 2>/dev/null)
}

# Fonction pour traiter tous les scripts
process_all_scripts() {
    log_info "Configuration des permissions d'exécution..."
    
    # Scripts Unix/Linux
    log_info "Traitement des scripts Unix/Linux..."
    process_directory "$SCRIPT_DIR/unix" "*.sh"
    process_directory "$SCRIPT_DIR/cross-platform" "*.sh"
    
    # Scripts Windows PowerShell
    log_info "Traitement des scripts PowerShell..."
    process_directory "$SCRIPT_DIR/windows/powershell" "*.ps1"
    
    # Scripts Windows Batch
    log_info "Traitement des scripts Batch..."
    process_directory "$SCRIPT_DIR/windows/batch" "*.bat"
    
    # Scripts de test
    log_info "Traitement des scripts de test..."
    process_directory "$SCRIPT_DIR/tests" "*.sh"
    
    # Script principal
    log_info "Traitement du script principal..."
    set_executable_permission "$SCRIPT_DIR/setup-permissions.sh"
    ((TOTAL_SCRIPTS++))
}

# Fonction pour afficher un résumé
show_summary() {
    echo
    echo "=== RÉSUMÉ DE LA CONFIGURATION ==="
    echo "Mode: $($DRY_RUN && echo "Simulation" || echo "Réel")"
    echo "Total des scripts trouvés: $TOTAL_SCRIPTS"
    echo "Scripts modifiés: $MODIFIED_SCRIPTS"
    echo "Scripts ignorés (déjà exécutables): $SKIPPED_SCRIPTS"
    
    if $DRY_RUN; then
        echo
        log_info "Simulation terminée. Utilisez --force pour appliquer les modifications."
    else
        echo
        log_info "Configuration terminée avec succès!"
    fi
}

# Fonction principale
main() {
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
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
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
    
    # Log du démarrage
    log_info "Démarrage de la configuration des permissions"
    log_debug "Répertoire du projet: $SCRIPT_DIR"
    log_debug "Mode simulation: $DRY_RUN"
    log_debug "Mode force: $FORCE"
    
    # Demander confirmation sauf si --force ou --dry-run
    if ! $FORCE && ! $DRY_RUN; then
        echo
        echo "Ce script va modifier les permissions d'exécution pour tous les scripts du projet."
        echo "Types de fichiers traités:"
        echo "  - Scripts Bash (.sh)"
        echo "  - Scripts PowerShell (.ps1)"
        echo "  - Scripts Batch (.bat)"
        echo
        read -p "Continuer? (o/N): " -r
        if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
            log_info "Configuration annulée par l'utilisateur"
            exit 0
        fi
    fi
    
    # Traiter tous les scripts
    process_all_scripts
    
    # Afficher le résumé
    show_summary
}

# Point d'entrée
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 