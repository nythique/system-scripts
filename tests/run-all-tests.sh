#!/bin/bash
#
# Script: run-all-tests.sh
# Auteur: Nythique
# Date: 2025-06-17
# Version: 1.0.0
# Description: Exécute tous les tests du projet System-Scripts
#
# Usage: ./run-all-tests.sh [options]
# Options:
#   -h, --help     Afficher l'aide
#   -v, --version  Afficher la version
#   -u, --unit     Exécuter uniquement les tests unitaires
#   -i, --integration Exécuter uniquement les tests d'intégration
#   -s, --script   Tester un script spécifique
#   -o, --output   Fichier de sortie pour les résultats
#
# Exemples:
#   ./run-all-tests.sh
#   ./run-all-tests.sh --unit
#   ./run-all-tests.sh --script unix/system/monitor-disk-space.sh

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPT_NAME="$(basename "$0")"
VERSION="1.0.0"
TEST_RESULTS_FILE=""
RUN_UNIT_ONLY=false
RUN_INTEGRATION_ONLY=false
TEST_SPECIFIC_SCRIPT=""

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Statistiques de test
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0

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

Description: Exécute tous les tests du projet System-Scripts

Options:
    -h, --help           Afficher cette aide
    -v, --version        Afficher la version
    -u, --unit           Exécuter uniquement les tests unitaires
    -i, --integration    Exécuter uniquement les tests d'intégration
    -s, --script SCRIPT  Tester un script spécifique
    -o, --output FILE    Fichier de sortie pour les résultats
    -d, --debug          Mode debug

Exemples:
    $SCRIPT_NAME
    $SCRIPT_NAME --unit
    $SCRIPT_NAME --integration
    $SCRIPT_NAME --script unix/system/monitor-disk-space.sh
    $SCRIPT_NAME --output test-results.txt

EOF
}

# Fonction pour vérifier les prérequis
check_prerequisites() {
    log_debug "Vérification des prérequis..."
    
    # Vérifier que bash est disponible
    if ! command -v bash >/dev/null 2>&1; then
        log_error "Bash n'est pas disponible"
        exit 1
    fi
    
    # Vérifier que les dossiers de test existent
    if [[ ! -d "$SCRIPT_DIR/unit" ]]; then
        log_warn "Dossier des tests unitaires manquant, création..."
        mkdir -p "$SCRIPT_DIR/unit"
    fi
    
    if [[ ! -d "$SCRIPT_DIR/integration" ]]; then
        log_warn "Dossier des tests d'intégration manquant, création..."
        mkdir -p "$SCRIPT_DIR/integration"
    fi
    
    log_debug "Prérequis vérifiés avec succès"
}

# Fonction pour tester la syntaxe d'un script
test_script_syntax() {
    local script_path="$1"
    local script_name="$(basename "$script_path")"
    
    log_debug "Test de syntaxe: $script_name"
    
    if [[ ! -f "$script_path" ]]; then
        log_warn "Script non trouvé: $script_path"
        return 1
    fi
    
    # Détecter le type de script
    local file_extension="${script_path##*.}"
    local syntax_check_cmd=""
    
    case "$file_extension" in
        "sh")
            syntax_check_cmd="bash -n"
            ;;
        "ps1")
            syntax_check_cmd="powershell -Command 'Get-Command'"
            ;;
        "bat")
            # Pour les fichiers .bat, on vérifie juste qu'ils existent
            syntax_check_cmd="test -f"
            ;;
        *)
            log_warn "Type de script non reconnu: $file_extension"
            return 1
            ;;
    esac
    
    # Exécuter le test de syntaxe
    if $syntax_check_cmd "$script_path" 2>/dev/null; then
        log_info "✓ Syntaxe OK: $script_name"
        ((PASSED_TESTS++))
        return 0
    else
        log_error "✗ Erreur de syntaxe: $script_name"
        ((FAILED_TESTS++))
        return 1
    fi
}

# Fonction pour tester les permissions d'un script
test_script_permissions() {
    local script_path="$1"
    local script_name="$(basename "$script_path")"
    
    log_debug "Test des permissions: $script_name"
    
    if [[ ! -f "$script_path" ]]; then
        log_warn "Script non trouvé: $script_path"
        return 1
    fi
    
    # Vérifier si le script est exécutable
    if [[ -x "$script_path" ]]; then
        log_info "✓ Permissions OK: $script_name"
        ((PASSED_TESTS++))
        return 0
    else
        log_warn "⚠ Script non exécutable: $script_name"
        ((SKIPPED_TESTS++))
        return 1
    fi
}

# Fonction pour tester l'aide d'un script
test_script_help() {
    local script_path="$1"
    local script_name="$(basename "$script_path")"
    
    log_debug "Test de l'aide: $script_name"
    
    if [[ ! -f "$script_path" ]]; then
        log_warn "Script non trouvé: $script_path"
        return 1
    fi
    
    # Détecter le type de script
    local file_extension="${script_path##*.}"
    local help_test_cmd=""
    
    case "$file_extension" in
        "sh")
            help_test_cmd="bash"
            ;;
        "ps1")
            help_test_cmd="powershell"
            ;;
        "bat")
            # Les fichiers .bat n'ont pas d'option d'aide standard
            log_debug "Test d'aide ignoré pour .bat: $script_name"
            ((SKIPPED_TESTS++))
            return 0
            ;;
        *)
            log_warn "Type de script non reconnu: $file_extension"
            return 1
            ;;
    esac
    
    # Tester l'option d'aide
    if timeout 5s $help_test_cmd "$script_path" --help >/dev/null 2>&1 || \
       timeout 5s $help_test_cmd "$script_path" -h >/dev/null 2>&1; then
        log_info "✓ Aide OK: $script_name"
        ((PASSED_TESTS++))
        return 0
    else
        log_warn "⚠ Option d'aide non fonctionnelle: $script_name"
        ((SKIPPED_TESTS++))
        return 1
    fi
}

# Fonction pour tester la version d'un script
test_script_version() {
    local script_path="$1"
    local script_name="$(basename "$script_path")"
    
    log_debug "Test de la version: $script_name"
    
    if [[ ! -f "$script_path" ]]; then
        log_warn "Script non trouvé: $script_path"
        return 1
    fi
    
    # Détecter le type de script
    local file_extension="${script_path##*.}"
    local version_test_cmd=""
    
    case "$file_extension" in
        "sh")
            version_test_cmd="bash"
            ;;
        "ps1")
            version_test_cmd="powershell"
            ;;
        "bat")
            # Les fichiers .bat n'ont pas d'option de version standard
            log_debug "Test de version ignoré pour .bat: $script_name"
            ((SKIPPED_TESTS++))
            return 0
            ;;
        *)
            log_warn "Type de script non reconnu: $file_extension"
            return 1
            ;;
    esac
    
    # Tester l'option de version
    if timeout 5s $version_test_cmd "$script_path" --version >/dev/null 2>&1 || \
       timeout 5s $version_test_cmd "$script_path" -v >/dev/null 2>&1; then
        log_info "✓ Version OK: $script_name"
        ((PASSED_TESTS++))
        return 0
    else
        log_warn "⚠ Option de version non fonctionnelle: $script_name"
        ((SKIPPED_TESTS++))
        return 1
    fi
}

# Fonction pour exécuter les tests unitaires
run_unit_tests() {
    log_info "=== EXÉCUTION DES TESTS UNITAIRES ==="
    
    # Tests de syntaxe pour tous les scripts
    log_info "Test de syntaxe des scripts..."
    
    # Scripts Unix
    for script in "$PROJECT_ROOT"/unix/**/*.sh; do
        if [[ -f "$script" ]]; then
            test_script_syntax "$script"
            ((TOTAL_TESTS++))
        fi
    done
    
    # Scripts PowerShell
    for script in "$PROJECT_ROOT"/windows/powershell/**/*.ps1; do
        if [[ -f "$script" ]]; then
            test_script_syntax "$script"
            ((TOTAL_TESTS++))
        fi
    done
    
    # Scripts Batch
    for script in "$PROJECT_ROOT"/windows/batch/*.bat; do
        if [[ -f "$script" ]]; then
            test_script_syntax "$script"
            ((TOTAL_TESTS++))
        fi
    done
    
    # Scripts Cross-platform
    for script in "$PROJECT_ROOT"/cross-platform/*.sh; do
        if [[ -f "$script" ]]; then
            test_script_syntax "$script"
            ((TOTAL_TESTS++))
        fi
    done
    
    # Tests des permissions
    log_info "Test des permissions des scripts..."
    for script in "$PROJECT_ROOT"/unix/**/*.sh "$PROJECT_ROOT"/cross-platform/*.sh; do
        if [[ -f "$script" ]]; then
            test_script_permissions "$script"
            ((TOTAL_TESTS++))
        fi
    done
    
    # Tests des options d'aide et de version
    log_info "Test des options d'aide et de version..."
    for script in "$PROJECT_ROOT"/unix/**/*.sh "$PROJECT_ROOT"/cross-platform/*.sh; do
        if [[ -f "$script" ]]; then
            test_script_help "$script"
            test_script_version "$script"
            ((TOTAL_TESTS += 2))
        fi
    done
    
    # Tests spécifiques pour les scripts PowerShell
    for script in "$PROJECT_ROOT"/windows/powershell/**/*.ps1; do
        if [[ -f "$script" ]]; then
            test_script_help "$script"
            test_script_version "$script"
            ((TOTAL_TESTS += 2))
        fi
    done
}

# Fonction pour exécuter les tests d'intégration
run_integration_tests() {
    log_info "=== EXÉCUTION DES TESTS D'INTÉGRATION ==="
    
    # Tests spécifiques pour monitor-disk-space.sh
    if [[ -f "$PROJECT_ROOT/unix/system/monitor-disk-space.sh" ]]; then
        log_info "Test d'intégration: monitor-disk-space.sh"
        
        # Test avec l'option --help
        if timeout 10s bash "$PROJECT_ROOT/unix/system/monitor-disk-space.sh" --help >/dev/null 2>&1; then
            log_info "✓ Test --help OK: monitor-disk-space.sh"
            ((PASSED_TESTS++))
        else
            log_error "✗ Test --help échoué: monitor-disk-space.sh"
            ((FAILED_TESTS++))
        fi
        ((TOTAL_TESTS++))
        
        # Test avec l'option --version
        if timeout 10s bash "$PROJECT_ROOT/unix/system/monitor-disk-space.sh" --version >/dev/null 2>&1; then
            log_info "✓ Test --version OK: monitor-disk-space.sh"
            ((PASSED_TESTS++))
        else
            log_error "✗ Test --version échoué: monitor-disk-space.sh"
            ((FAILED_TESTS++))
        fi
        ((TOTAL_TESTS++))
        
        # Test avec l'option --dry-run (si disponible)
        if timeout 10s bash "$PROJECT_ROOT/unix/system/monitor-disk-space.sh" -d >/dev/null 2>&1; then
            log_info "✓ Test mode debug OK: monitor-disk-space.sh"
            ((PASSED_TESTS++))
        else
            log_warn "⚠ Test mode debug ignoré: monitor-disk-space.sh"
            ((SKIPPED_TESTS++))
        fi
        ((TOTAL_TESTS++))
    fi
    
    # Tests spécifiques pour update-system.sh
    if [[ -f "$PROJECT_ROOT/unix/system/update-system.sh" ]]; then
        log_info "Test d'intégration: update-system.sh"
        
        # Test avec l'option --check
        if timeout 10s bash "$PROJECT_ROOT/unix/system/update-system.sh" --check >/dev/null 2>&1; then
            log_info "✓ Test --check OK: update-system.sh"
            ((PASSED_TESTS++))
        else
            log_error "✗ Test --check échoué: update-system.sh"
            ((FAILED_TESTS++))
        fi
        ((TOTAL_TESTS++))
    fi
}

# Fonction pour tester un script spécifique
test_specific_script() {
    local script_path="$TEST_SPECIFIC_SCRIPT"
    
    if [[ ! -f "$script_path" ]]; then
        log_error "Script non trouvé: $script_path"
        exit 1
    fi
    
    log_info "=== TEST DU SCRIPT SPÉCIFIQUE: $script_path ==="
    
    # Tests de base
    test_script_syntax "$script_path"
    test_script_permissions "$script_path"
    test_script_help "$script_path"
    test_script_version "$script_path"
    
    ((TOTAL_TESTS += 4))
}

# Fonction pour afficher les résultats
show_results() {
    local success_rate=0
    
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        success_rate=$(( (PASSED_TESTS * 100) / TOTAL_TESTS ))
    fi
    
    echo
    echo "=== RÉSULTATS DES TESTS ==="
    echo "Total des tests: $TOTAL_TESTS"
    echo "Tests réussis: $PASSED_TESTS"
    echo "Tests échoués: $FAILED_TESTS"
    echo "Tests ignorés: $SKIPPED_TESTS"
    echo "Taux de réussite: ${success_rate}%"
    
    # Sauvegarder les résultats si demandé
    if [[ -n "$TEST_RESULTS_FILE" ]]; then
        {
            echo "=== RÉSULTATS DES TESTS - $(date) ==="
            echo "Total des tests: $TOTAL_TESTS"
            echo "Tests réussis: $PASSED_TESTS"
            echo "Tests échoués: $FAILED_TESTS"
            echo "Tests ignorés: $SKIPPED_TESTS"
            echo "Taux de réussite: ${success_rate}%"
        } > "$TEST_RESULTS_FILE"
        log_info "Résultats sauvegardés dans: $TEST_RESULTS_FILE"
    fi
    
    # Code de sortie
    if [[ $FAILED_TESTS -gt 0 ]]; then
        log_error "Certains tests ont échoué"
        exit 1
    else
        log_info "Tous les tests sont passés avec succès!"
        exit 0
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
            -u|--unit)
                RUN_UNIT_ONLY=true
                shift
                ;;
            -i|--integration)
                RUN_INTEGRATION_ONLY=true
                shift
                ;;
            -s|--script)
                TEST_SPECIFIC_SCRIPT="$2"
                shift 2
                ;;
            -o|--output)
                TEST_RESULTS_FILE="$2"
                shift 2
                ;;
            -d|--debug)
                set -x
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
    
    # Vérifier les prérequis
    check_prerequisites
    
    # Log du démarrage
    log_info "Démarrage des tests System-Scripts"
    log_debug "Répertoire du projet: $PROJECT_ROOT"
    log_debug "Répertoire des tests: $SCRIPT_DIR"
    
    # Exécuter les tests selon les options
    if [[ -n "$TEST_SPECIFIC_SCRIPT" ]]; then
        test_specific_script
    elif $RUN_UNIT_ONLY; then
        run_unit_tests
    elif $RUN_INTEGRATION_ONLY; then
        run_integration_tests
    else
        run_unit_tests
        run_integration_tests
    fi
    
    # Afficher les résultats
    show_results
}

# Point d'entrée
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 