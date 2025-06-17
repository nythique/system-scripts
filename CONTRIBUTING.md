# Guide de Contribution

Merci de votre intérêt pour contribuer au projet System-Scripts ! Ce document contient les directives pour contribuer efficacement au projet.

## 📋 Table des matières

- [Code de conduite](#code-de-conduite)
- [Comment contribuer](#comment-contribuer)
- [Standards de développement](#standards-de-développement)
- [Processus de soumission](#processus-de-soumission)
- [Tests](#tests)
- [Documentation](#documentation)
- [Questions et support](#questions-et-support)

## 🤝 Code de conduite

### Nos standards

Nous nous engageons à maintenir un environnement ouvert et accueillant. En participant à ce projet, vous acceptez de :

- Être respectueux et inclusif
- Utiliser un langage approprié
- Accepter les critiques constructives
- Se concentrer sur ce qui est le mieux pour la communauté
- Faire preuve d'empathie envers les autres membres

### Nos responsabilités

Les mainteneurs du projet sont responsables de :

- Clarifier les standards de comportement acceptable
- Prendre des mesures correctives appropriées et équitables
- Supprimer, éditer ou rejeter les commentaires, commits, code et autres contributions qui ne respectent pas ce Code de Conduite

## 🚀 Comment contribuer

### Types de contributions

Nous accueillons différents types de contributions :

#### 🐛 Signaler des bugs
- Utilisez le template d'issue pour les bugs
- Incluez des étapes de reproduction détaillées
- Spécifiez votre environnement (OS, version, etc.)

#### 💡 Proposer des améliorations
- Ouvrez une issue pour discuter de l'amélioration
- Décrivez clairement le problème et la solution proposée
- Attendez l'approbation avant de commencer le développement

#### 🔧 Améliorer la documentation
- Corrigez les erreurs de documentation
- Améliorez la clarté et la structure
- Ajoutez des exemples d'utilisation

#### ✨ Ajouter de nouveaux scripts
- Proposez le script via une issue
- Suivez les conventions de nommage
- Incluez la documentation et les tests

### Processus de développement

1. **Fork le repository**
   ```bash
   git clone https://github.com/votre-username/system-scripts.git
   cd system-scripts
   ```

2. **Créer une branche**
   ```bash
   git checkout -b feature/nom-de-la-fonctionnalite
   # ou
   git checkout -b fix/nom-du-bug
   ```

3. **Développer votre fonctionnalité**
   - Suivez les standards de code
   - Écrivez des tests
   - Documentez vos changements

4. **Tester vos modifications**
   ```bash
   # Tests unitaires
   ./tests/run-tests.sh
   
   # Tests d'intégration
   ./tests/integration-tests.sh
   ```

5. **Commiter vos changements**
   ```bash
   git add .
   git commit -m "feat: ajouter nouvelle fonctionnalité X"
   ```

6. **Pousser vers votre fork**
   ```bash
   git push origin feature/nom-de-la-fonctionnalite
   ```

7. **Créer une Pull Request**
   - Utilisez le template de PR
   - Décrivez clairement les changements
   - Référencez les issues concernées

## 📝 Standards de développement

### Conventions de nommage

#### Fichiers et dossiers
- **Unix scripts** : `kebab-case.sh` (ex: `monitor-disk-space.sh`)
- **Windows scripts** : `kebab-case.ps1` ou `kebab-case.bat`
- **Dossiers** : `kebab-case` (ex: `cross-platform`)

#### Variables et fonctions
- **Bash** : `UPPER_CASE` pour les variables globales, `lower_case` pour les locales
- **PowerShell** : `PascalCase` pour les fonctions, `camelCase` pour les variables
- **Batch** : `UPPER_CASE` pour les variables

### Structure des scripts

#### Scripts Bash
```bash
#!/bin/bash
#
# Nom du script: description courte
# Auteur: Votre nom
# Date: YYYY-MM-DD
# Version: 1.0.0
# Description: Description détaillée du script
#
# Usage: ./script-name.sh [options] [arguments]
# Options:
#   -h, --help     Afficher l'aide
#   -v, --version  Afficher la version
#
# Exemples:
#   ./script-name.sh
#   ./script-name.sh --help
#

set -euo pipefail  # Arrêter sur erreur, variables non définies, erreurs de pipeline

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "$0")"
VERSION="1.0.0"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

# Fonction d'aide
show_help() {
    cat << EOF
Usage: $SCRIPT_NAME [options] [arguments]

Description: Description détaillée du script

Options:
    -h, --help     Afficher cette aide
    -v, --version  Afficher la version
    -d, --debug    Mode debug

Arguments:
    arg1           Description du premier argument
    arg2           Description du second argument

Exemples:
    $SCRIPT_NAME
    $SCRIPT_NAME --help
    $SCRIPT_NAME arg1 arg2

EOF
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
            -d|--debug)
                set -x
                shift
                ;;
            *)
                log_error "Option inconnue: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Logique principale du script
    log_info "Démarrage du script..."
    
    # Votre code ici
    
    log_info "Script terminé avec succès"
}

# Point d'entrée
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

#### Scripts PowerShell
```powershell
<#
.SYNOPSIS
    Description courte du script

.DESCRIPTION
    Description détaillée du script et de ses fonctionnalités

.PARAMETER Parameter1
    Description du premier paramètre

.PARAMETER Parameter2
    Description du second paramètre

.EXAMPLE
    .\script-name.ps1 -Parameter1 "value1" -Parameter2 "value2"

.EXAMPLE
    .\script-name.ps1 -Help

.NOTES
    Auteur: Votre nom
    Date: YYYY-MM-DD
    Version: 1.0.0
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false, HelpMessage="Description du paramètre")]
    [string]$Parameter1,
    
    [Parameter(Mandatory=$false, HelpMessage="Description du paramètre")]
    [string]$Parameter2,
    
    [Parameter(Mandatory=$false)]
    [switch]$Help,
    
    [Parameter(Mandatory=$false)]
    [switch]$Version
)

# Configuration
$ScriptName = $MyInvocation.MyCommand.Name
$ScriptVersion = "1.0.0"

# Fonctions utilitaires
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Show-Help {
    Get-Help $MyInvocation.MyCommand.Path -Full
}

function Show-Version {
    Write-Host "$ScriptName version $ScriptVersion"
}

# Fonction principale
function Main {
    if ($Help) {
        Show-Help
        return
    }
    
    if ($Version) {
        Show-Version
        return
    }
    
    Write-Info "Démarrage du script..."
    
    # Votre code ici
    
    Write-Info "Script terminé avec succès"
}

# Point d'entrée
try {
    Main
}
catch {
    Write-Error "Erreur: $($_.Exception.Message)"
    exit 1
}
```

### Bonnes pratiques

#### Sécurité
- Validez toujours les entrées utilisateur
- Utilisez des chemins absolus quand possible
- Évitez l'utilisation de `eval` ou `exec`
- Gérez les permissions de fichiers appropriées

#### Performance
- Évitez les boucles inutiles
- Utilisez des commandes natives quand possible
- Optimisez les opérations de fichiers

#### Maintenabilité
- Commentez le code complexe
- Utilisez des noms de variables descriptifs
- Divisez les scripts longs en fonctions
- Suivez le principe DRY (Don't Repeat Yourself)

## 🧪 Tests

### Structure des tests

```
tests/
├── unit/              # Tests unitaires
├── integration/       # Tests d'intégration
├── fixtures/          # Données de test
└── scripts/           # Scripts de test
```

### Écrire des tests

#### Tests Bash
```bash
#!/bin/bash
# test-script-name.sh

source "$(dirname "$0")/../unix/system/script-name.sh"

# Tests
test_function_name() {
    local result
    result=$(function_name "test_input")
    
    if [[ "$result" == "expected_output" ]]; then
        echo "✓ test_function_name: PASS"
    else
        echo "✗ test_function_name: FAIL (expected: expected_output, got: $result)"
        return 1
    fi
}

# Exécution des tests
test_function_name
```

#### Tests PowerShell
```powershell
# test-script-name.tests.ps1

Describe "Script-Name Tests" {
    BeforeAll {
        . "$PSScriptRoot\..\windows\powershell\system\script-name.ps1"
    }
    
    Context "Function Tests" {
        It "Should return expected output" {
            $result = Function-Name "test_input"
            $result | Should -Be "expected_output"
        }
    }
}
```

### Exécuter les tests

```bash
# Tests unitaires
./tests/run-unit-tests.sh

# Tests d'intégration
./tests/run-integration-tests.sh

# Tous les tests
./tests/run-all-tests.sh
```

## 📚 Documentation

### Standards de documentation

- Utilisez un langage clair et concis
- Incluez des exemples d'utilisation
- Documentez tous les paramètres et options
- Maintenez la documentation à jour

### Types de documentation

1. **Documentation inline** : Commentaires dans le code
2. **Documentation d'API** : Description des fonctions et paramètres
3. **Documentation utilisateur** : Guides d'utilisation
4. **Documentation technique** : Architecture et design

## 🔄 Processus de soumission

### Pull Request Template

```markdown
## Description
Bref résumé des changements

## Type de changement
- [ ] Bug fix
- [ ] Nouvelle fonctionnalité
- [ ] Amélioration de la documentation
- [ ] Refactoring
- [ ] Test

## Tests
- [ ] Tests unitaires passent
- [ ] Tests d'intégration passent
- [ ] Tests manuels effectués

## Checklist
- [ ] Mon code suit les standards du projet
- [ ] J'ai auto-révisé mon code
- [ ] J'ai commenté mon code, particulièrement dans les zones difficiles
- [ ] J'ai fait les changements correspondants dans la documentation
- [ ] Mes changements ne génèrent pas de nouveaux warnings
- [ ] J'ai ajouté des tests qui prouvent que ma correction fonctionne
- [ ] Les tests passent avec mes changements
- [ ] J'ai mis à jour les fichiers de version si nécessaire

## Screenshots (si applicable)
Ajoutez des captures d'écran pour illustrer vos changements

## Informations supplémentaires
Toute information supplémentaire ou contexte
```

### Processus de review

1. **Auto-review** : Vérifiez votre code avant de soumettre
2. **Review par les mainteneurs** : Attendez la review
3. **Corrections** : Apportez les corrections demandées
4. **Approval** : Une fois approuvé, le code sera mergé

## ❓ Questions et support

### Obtenir de l'aide

- **Issues** : Pour les bugs et demandes de fonctionnalités
- **Discussions** : Pour les questions générales
- **Documentation** : Consultez les guides existants

### Ressources utiles

- [Guide Bash](https://www.gnu.org/software/bash/manual/)
- [Documentation PowerShell](https://docs.microsoft.com/en-us/powershell/)
- [Bonnes pratiques de scripting](https://google.github.io/styleguide/shellguide.html)

## 🎯 Prochaines étapes

Après avoir lu ce guide :

1. Choisissez une issue à travailler
2. Créez votre branche de développement
3. Développez et testez votre solution
4. Soumettez votre Pull Request

Merci de contribuer à System-Scripts ! 🚀
