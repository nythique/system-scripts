#!/bin/bash
#
# Configuration des tests: test-config.sh
# Auteur: Nythique
# Date: 2025-06-17
# Version: 1.0.0
# Description: Configuration centralisée pour tous les tests
#

# Configuration générale
TEST_TIMEOUT=30          # Timeout en secondes pour les tests
TEST_LOG_DIR="/tmp"      # Répertoire pour les logs de test
TEST_RESULTS_DIR="/tmp"  # Répertoire pour les résultats de test

# Couleurs pour les messages de test
TEST_COLOR_RED='\033[0;31m'
TEST_COLOR_GREEN='\033[0;32m'
TEST_COLOR_YELLOW='\033[1;33m'
TEST_COLOR_BLUE='\033[0;34m'
TEST_COLOR_PURPLE='\033[0;35m'
TEST_COLOR_CYAN='\033[0;36m'
TEST_COLOR_NC='\033[0m' # No Color

# Codes de sortie
TEST_EXIT_SUCCESS=0
TEST_EXIT_FAILURE=1
TEST_EXIT_SKIP=2

# Types de tests
TEST_TYPE_UNIT="unit"
TEST_TYPE_INTEGRATION="integration"
TEST_TYPE_FUNCTIONAL="functional"
TEST_TYPE_PERFORMANCE="performance"

# Niveaux de verbosité
TEST_VERBOSITY_QUIET=0
TEST_VERBOSITY_NORMAL=1
TEST_VERBOSITY_VERBOSE=2
TEST_VERBOSITY_DEBUG=3

# Configuration par plateforme
case "$(uname -s)" in
    Linux*)
        TEST_PLATFORM="linux"
        TEST_SHELL="bash"
        TEST_PS1_CMD="bash"
        ;;
    Darwin*)
        TEST_PLATFORM="macos"
        TEST_SHELL="bash"
        TEST_PS1_CMD="bash"
        ;;
    CYGWIN*|MINGW*|MSYS*)
        TEST_PLATFORM="windows"
        TEST_SHELL="bash"
        TEST_PS1_CMD="powershell"
        ;;
    *)
        TEST_PLATFORM="unknown"
        TEST_SHELL="bash"
        TEST_PS1_CMD="bash"
        ;;
esac

# Configuration des scripts à tester
declare -A TEST_SCRIPTS=(
    # Scripts Unix
    ["monitor-disk-space"]="unix/system/monitor-disk-space.sh"
    ["update-system"]="unix/system/update-system.sh"
    ["cleanup-temp"]="unix/system/cleanup-temp.sh"
    ["cron-health-check"]="unix/system/cron-health-check.sh"
    
    # Scripts de développement
    ["backup-project"]="unix/dev/backup-project.sh"
    ["git-auto-commit"]="unix/dev/git-auto-commit.sh"
    ["start-dev-env"]="unix/dev/start-dev-env.sh"
    
    # Scripts de sécurité
    ["port-scanner"]="unix/security/port-scanner.sh"
    ["ssh-key-check"]="unix/security/ssh-key-check.sh"
    
    # Scripts utilitaires
    ["battery-alert"]="unix/original/battery-alert.sh"
    ["generate-password"]="unix/original/generate-password.sh"
    ["slow-internet-detector"]="unix/original/slow-internet-detector.sh"
    
    # Scripts PowerShell
    ["clear-windows-cache"]="windows/powershell/system/clear-windows-cache.ps1"
    ["disable-unwanted-services"]="windows/powershell/system/disable-unwanted-services.ps1"
    ["windows-update"]="windows/powershell/system/windows-update.ps1"
    ["create-users-bulk"]="windows/powershell/admin/create-users-bulk.ps1"
    ["export-installed-software"]="windows/powershell/admin/export-installed-software.ps1"
    
    # Scripts Batch
    ["launch-dev-env"]="windows/batch/launch-dev-env.bat"
    ["ping-check"]="windows/batch/ping-check.bat"
    ["usb-backup"]="windows/batch/usb-backup.bat"
    
    # Scripts Cross-platform
    ["check-network-status"]="cross-platform/check-network-status.sh"
    ["daily-backup"]="cross-platform/daily-backup.sh"
    ["sync-folders"]="cross-platform/sync-folders.sh"
)

# Configuration des tests par script
declare -A TEST_OPTIONS=(
    # monitor-disk-space.sh
    ["monitor-disk-space"]="--help --version --threshold 85 --critical 95 --email test@example.com"
    
    # update-system.sh
    ["update-system"]="--help --version --check --security --dry-run"
    
    # clear-windows-cache.ps1
    ["clear-windows-cache"]="-Help -Version -WhatIf -Force"
)

# Configuration des tests d'intégration
declare -A INTEGRATION_TESTS=(
    ["monitor-disk-space"]="--help --version -d --threshold 80 --critical 90"
    ["update-system"]="--help --version --check --dry-run"
    ["clear-windows-cache"]="-Help -Version -WhatIf"
)

# Configuration des tests de performance
declare -A PERFORMANCE_TESTS=(
    ["monitor-disk-space"]="timeout 5s"
    ["update-system"]="timeout 10s"
    ["clear-windows-cache"]="timeout 15s"
)

# Fonctions utilitaires pour les tests
test_log() {
    local level="$1"
    local message="$2"
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    
    case "$level" in
        "INFO")
            echo -e "${TEST_COLOR_GREEN}[INFO]${TEST_COLOR_NC} $message"
            ;;
        "WARN")
            echo -e "${TEST_COLOR_YELLOW}[WARN]${TEST_COLOR_NC} $message"
            ;;
        "ERROR")
            echo -e "${TEST_COLOR_RED}[ERROR]${TEST_COLOR_NC} $message"
            ;;
        "DEBUG")
            echo -e "${TEST_COLOR_BLUE}[DEBUG]${TEST_COLOR_NC} $message"
            ;;
        *)
            echo "[$level] $message"
            ;;
    esac
    
    # Log dans un fichier si configuré
    if [[ -n "$TEST_LOG_FILE" ]]; then
        echo "$timestamp [$level] $message" >> "$TEST_LOG_FILE"
    fi
}

test_info() {
    test_log "INFO" "$1"
}

test_warn() {
    test_log "WARN" "$1"
}

test_error() {
    test_log "ERROR" "$1"
}

test_debug() {
    test_log "DEBUG" "$1"
}

# Fonction pour vérifier les prérequis
test_check_prerequisites() {
    local missing_tools=()
    
    # Vérifier bash
    if ! command -v bash >/dev/null 2>&1; then
        missing_tools+=("bash")
    fi
    
    # Vérifier timeout (pour Linux)
    if [[ "$TEST_PLATFORM" == "linux" ]] && ! command -v timeout >/dev/null 2>&1; then
        missing_tools+=("timeout")
    fi
    
    # Vérifier PowerShell (pour Windows)
    if [[ "$TEST_PLATFORM" == "windows" ]] && ! command -v powershell >/dev/null 2>&1; then
        missing_tools+=("powershell")
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        test_error "Outils manquants: ${missing_tools[*]}"
        return 1
    fi
    
    return 0
}

# Fonction pour obtenir le chemin d'un script
test_get_script_path() {
    local script_name="$1"
    local script_path="${TEST_SCRIPTS[$script_name]}"
    
    if [[ -z "$script_path" ]]; then
        test_error "Script non trouvé: $script_name"
        return 1
    fi
    
    # Construire le chemin complet
    local project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    echo "$project_root/$script_path"
}

# Fonction pour exécuter un test avec timeout
test_run_with_timeout() {
    local timeout="$1"
    local command="$2"
    local expected_exit="${3:-0}"
    
    if [[ "$TEST_PLATFORM" == "linux" ]]; then
        timeout "${timeout}s" bash -c "$command"
    else
        # Pour les autres plateformes, exécuter sans timeout
        bash -c "$command"
    fi
    
    local exit_code=$?
    
    if [[ $exit_code -eq $expected_exit ]]; then
        return 0
    else
        return 1
    fi
}

# Fonction pour nettoyer les fichiers de test
test_cleanup() {
    local test_files=(
        "$TEST_LOG_DIR/test-*.log"
        "$TEST_RESULTS_DIR/test-*.txt"
        "/tmp/test-*.tmp"
    )
    
    for pattern in "${test_files[@]}"; do
        if [[ -e "$pattern" ]]; then
            rm -f "$pattern" 2>/dev/null || true
        fi
    done
}

# Fonction pour créer un rapport de test
test_create_report() {
    local report_file="$1"
    local test_name="$2"
    local test_results="$3"
    
    {
        echo "=== RAPPORT DE TEST ==="
        echo "Date: $(date)"
        echo "Plateforme: $TEST_PLATFORM"
        echo "Script testé: $test_name"
        echo "Résultats: $test_results"
        echo "Configuration:"
        echo "  - Timeout: ${TEST_TIMEOUT}s"
        echo "  - Shell: $TEST_SHELL"
        echo "  - Log dir: $TEST_LOG_DIR"
    } > "$report_file"
}

# Export des variables et fonctions pour les scripts de test
export TEST_TIMEOUT TEST_LOG_DIR TEST_RESULTS_DIR
export TEST_COLOR_RED TEST_COLOR_GREEN TEST_COLOR_YELLOW TEST_COLOR_BLUE TEST_COLOR_NC
export TEST_EXIT_SUCCESS TEST_EXIT_FAILURE TEST_EXIT_SKIP
export TEST_TYPE_UNIT TEST_TYPE_INTEGRATION TEST_TYPE_FUNCTIONAL TEST_TYPE_PERFORMANCE
export TEST_PLATFORM TEST_SHELL TEST_PS1_CMD
export -f test_log test_info test_warn test_error test_debug
export -f test_check_prerequisites test_get_script_path test_run_with_timeout
export -f test_cleanup test_create_report 