#!/bin/bash
#
# Test unitaire: test-monitor-disk-space.sh
# Auteur: Nythique
# Date: 2025-06-17
# Version: 1.0.0
# Description: Tests unitaires pour monitor-disk-space.sh
#
# Usage: ./test-monitor-disk-space.sh
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TARGET_SCRIPT="$PROJECT_ROOT/unix/system/monitor-disk-space.sh"
SCRIPT_NAME="$(basename "$TARGET_SCRIPT")"

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

# Fonction pour exécuter un test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_exit_code="${3:-0}"
    
    log_debug "Exécution du test: $test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        local exit_code=$?
        if [[ $exit_code -eq $expected_exit_code ]]; then
            log_info "✓ PASS: $test_name"
            ((PASSED_TESTS++))
            return 0
        else
            log_error "✗ FAIL: $test_name (code de sortie: $exit_code, attendu: $expected_exit_code)"
            ((FAILED_TESTS++))
            return 1
        fi
    else
        local exit_code=$?
        if [[ $exit_code -eq $expected_exit_code ]]; then
            log_info "✓ PASS: $test_name"
            ((PASSED_TESTS++))
            return 0
        else
            log_error "✗ FAIL: $test_name (code de sortie: $exit_code, attendu: $expected_exit_code)"
            ((FAILED_TESTS++))
            return 1
        fi
    fi
}

# Test 1: Vérifier que le script existe
test_script_exists() {
    run_test "Script existe" "[[ -f '$TARGET_SCRIPT' ]]"
}

# Test 2: Vérifier que le script est exécutable
test_script_executable() {
    run_test "Script exécutable" "[[ -x '$TARGET_SCRIPT' ]]"
}

# Test 3: Vérifier la syntaxe du script
test_script_syntax() {
    run_test "Syntaxe valide" "bash -n '$TARGET_SCRIPT'"
}

# Test 4: Vérifier l'option --help
test_help_option() {
    run_test "Option --help" "bash '$TARGET_SCRIPT' --help"
}

# Test 5: Vérifier l'option -h
test_help_short_option() {
    run_test "Option -h" "bash '$TARGET_SCRIPT' -h"
}

# Test 6: Vérifier l'option --version
test_version_option() {
    run_test "Option --version" "bash '$TARGET_SCRIPT' --version"
}

# Test 7: Vérifier l'option -v
test_version_short_option() {
    run_test "Option -v" "bash '$TARGET_SCRIPT' -v"
}

# Test 8: Vérifier l'option --debug
test_debug_option() {
    run_test "Option --debug" "bash '$TARGET_SCRIPT' --debug --help"
}

# Test 9: Vérifier l'option -d
test_debug_short_option() {
    run_test "Option -d" "bash '$TARGET_SCRIPT' -d --help"
}

# Test 10: Vérifier l'option --threshold avec valeur valide
test_threshold_valid() {
    run_test "Option --threshold valide" "bash '$TARGET_SCRIPT' --threshold 85 --help"
}

# Test 11: Vérifier l'option -t avec valeur valide
test_threshold_short_valid() {
    run_test "Option -t valide" "bash '$TARGET_SCRIPT' -t 85 --help"
}

# Test 12: Vérifier l'option --critical avec valeur valide
test_critical_valid() {
    run_test "Option --critical valide" "bash '$TARGET_SCRIPT' --critical 95 --help"
}

# Test 13: Vérifier l'option -c avec valeur valide
test_critical_short_valid() {
    run_test "Option -c valide" "bash '$TARGET_SCRIPT' -c 95 --help"
}

# Test 14: Vérifier l'option --email avec valeur
test_email_option() {
    run_test "Option --email" "bash '$TARGET_SCRIPT' --email test@example.com --help"
}

# Test 15: Vérifier l'option -e avec valeur
test_email_short_option() {
    run_test "Option -e" "bash '$TARGET_SCRIPT' -e test@example.com --help"
}

# Test 16: Vérifier l'option --log avec valeur
test_log_option() {
    run_test "Option --log" "bash '$TARGET_SCRIPT' --log /tmp/test.log --help"
}

# Test 17: Vérifier l'option -l avec valeur
test_log_short_option() {
    run_test "Option -l" "bash '$TARGET_SCRIPT' -l /tmp/test.log --help"
}

# Test 18: Vérifier que le script fonctionne sans arguments (mode simulation)
test_no_arguments() {
    run_test "Sans arguments" "bash '$TARGET_SCRIPT'"
}

# Test 19: Vérifier avec un point de montage valide (mode simulation)
test_valid_mount_point() {
    run_test "Point de montage valide" "bash '$TARGET_SCRIPT' /"
}

# Test 20: Vérifier avec un point de montage invalide
test_invalid_mount_point() {
    run_test "Point de montage invalide" "bash '$TARGET_SCRIPT' /invalid/mount/point" 1
}

# Test 21: Vérifier l'option --threshold avec valeur invalide
test_threshold_invalid() {
    run_test "Option --threshold invalide" "bash '$TARGET_SCRIPT' --threshold 101" 1
}

# Test 22: Vérifier l'option --critical avec valeur invalide
test_critical_invalid() {
    run_test "Option --critical invalide" "bash '$TARGET_SCRIPT' --critical 0" 1
}

# Test 23: Vérifier que le seuil critique doit être supérieur au seuil d'alerte
test_threshold_greater_than_critical() {
    run_test "Seuil > Critique" "bash '$TARGET_SCRIPT' --threshold 95 --critical 85" 1
}

# Test 24: Vérifier l'option inconnue
test_unknown_option() {
    run_test "Option inconnue" "bash '$TARGET_SCRIPT' --unknown-option" 1
}

# Test 25: Vérifier trop d'arguments
test_too_many_arguments() {
    run_test "Trop d'arguments" "bash '$TARGET_SCRIPT' / /home" 1
}

# Test 26: Vérifier que les fonctions utilitaires sont définies
test_utility_functions() {
    run_test "Fonctions utilitaires" "bash -c 'source \"$TARGET_SCRIPT\"; declare -f log_info >/dev/null && declare -f log_warn >/dev/null && declare -f log_error >/dev/null'"
}

# Test 27: Vérifier que la fonction show_help est définie
test_help_function() {
    run_test "Fonction show_help" "bash -c 'source \"$TARGET_SCRIPT\"; declare -f show_help >/dev/null'"
}

# Test 28: Vérifier que la fonction main est définie
test_main_function() {
    run_test "Fonction main" "bash -c 'source \"$TARGET_SCRIPT\"; declare -f main >/dev/null'"
}

# Test 29: Vérifier que les variables globales sont définies
test_global_variables() {
    run_test "Variables globales" "bash -c 'source \"$TARGET_SCRIPT\"; [[ -n \"\$SCRIPT_NAME\" && -n \"\$VERSION\" ]]'"
}

# Test 30: Vérifier que les couleurs sont définies
test_color_variables() {
    run_test "Variables de couleur" "bash -c 'source \"$TARGET_SCRIPT\"; [[ -n \"\$RED\" && -n \"\$GREEN\" && -n \"\$YELLOW\" && -n \"\$NC\" ]]'"
}

# Fonction pour exécuter tous les tests
run_all_tests() {
    log_info "=== TESTS UNITAIRES POUR $SCRIPT_NAME ==="
    log_debug "Script cible: $TARGET_SCRIPT"
    
    # Tests de base
    test_script_exists
    test_script_executable
    test_script_syntax
    
    # Tests des options
    test_help_option
    test_help_short_option
    test_version_option
    test_version_short_option
    test_debug_option
    test_debug_short_option
    
    # Tests des paramètres
    test_threshold_valid
    test_threshold_short_valid
    test_critical_valid
    test_critical_short_valid
    test_email_option
    test_email_short_option
    test_log_option
    test_log_short_option
    
    # Tests de fonctionnement
    test_no_arguments
    test_valid_mount_point
    test_invalid_mount_point
    
    # Tests de validation
    test_threshold_invalid
    test_critical_invalid
    test_threshold_greater_than_critical
    test_unknown_option
    test_too_many_arguments
    
    # Tests des fonctions internes
    test_utility_functions
    test_help_function
    test_main_function
    test_global_variables
    test_color_variables
}

# Fonction pour afficher les résultats
show_results() {
    local success_rate=0
    
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        success_rate=$(( (PASSED_TESTS * 100) / TOTAL_TESTS ))
    fi
    
    echo
    echo "=== RÉSULTATS DES TESTS UNITAIRES ==="
    echo "Script testé: $SCRIPT_NAME"
    echo "Total des tests: $TOTAL_TESTS"
    echo "Tests réussis: $PASSED_TESTS"
    echo "Tests échoués: $FAILED_TESTS"
    echo "Taux de réussite: ${success_rate}%"
    
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
    # Vérifier que le script cible existe
    if [[ ! -f "$TARGET_SCRIPT" ]]; then
        log_error "Script cible non trouvé: $TARGET_SCRIPT"
        exit 1
    fi
    
    # Exécuter tous les tests
    run_all_tests
    
    # Afficher les résultats
    show_results
}

# Point d'entrée
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 