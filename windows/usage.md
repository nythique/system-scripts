# Scripts Windows

Collection de scripts d'automatisation système pour environnements Windows.

## 📋 Table des matières

- [Scripts PowerShell - Administration](#scripts-powershell---administration)
- [Scripts PowerShell - Système](#scripts-powershell---système)
- [Scripts Batch](#scripts-batch)
- [Installation et Configuration](#installation-et-configuration)
- [Utilisation](#utilisation)
- [Tests](#tests)
- [Dépannage](#dépannage)

## 🔧 Scripts PowerShell - Administration

### create-users-bulk.ps1
**Description** : Création d'utilisateurs en masse depuis un fichier CSV

**Usage** :
```powershell
.\windows\powershell\admin\create-users-bulk.ps1 [options]
```

**Options** :
- `-CsvFile` : Chemin vers le fichier CSV
- `-Help` : Afficher l'aide
- `-Version` : Afficher la version
- `-WhatIf` : Simulation sans créer d'utilisateurs
- `-Force` : Forcer la création sans confirmation

**Format CSV attendu** :
```csv
Username,FullName,Email,Department,Password
john.doe,John Doe,john.doe@company.com,IT,P@ssw0rd123
jane.smith,Jane Smith,jane.smith@company.com,HR,P@ssw0rd456
```

**Exemples** :
```powershell
# Création depuis un fichier CSV
.\windows\powershell\admin\create-users-bulk.ps1 -CsvFile "users.csv"

# Simulation de création
.\windows\powershell\admin\create-users-bulk.ps1 -CsvFile "users.csv" -WhatIf

# Création forcée
.\windows\powershell\admin\create-users-bulk.ps1 -CsvFile "users.csv" -Force
```

### export-installed-software.ps1
**Description** : Export de la liste des logiciels installés

**Usage** :
```powershell
.\windows\powershell\admin\export-installed-software.ps1 [options]
```

**Options** :
- `-OutputFile` : Fichier de sortie (défaut: installed-software.csv)
- `-Format` : Format de sortie (CSV, JSON, XML)
- `-IncludeUpdates` : Inclure les mises à jour Windows
- `-Help` : Afficher l'aide
- `-Version` : Afficher la version

**Exemples** :
```powershell
# Export au format CSV
.\windows\powershell\admin\export-installed-software.ps1

# Export au format JSON
.\windows\powershell\admin\export-installed-software.ps1 -Format JSON

# Export avec mises à jour
.\windows\powershell\admin\export-installed-software.ps1 -IncludeUpdates -OutputFile "software-list.csv"
```

## ⚙️ Scripts PowerShell - Système

### clear-windows-cache.ps1
**Description** : Nettoyage du cache Windows et des fichiers temporaires

**Usage** :
```powershell
.\windows\powershell\system\clear-windows-cache.ps1 [options]
```

**Options** :
- `-All` : Nettoyer tous les types de cache (par défaut)
- `-TempFiles` : Nettoyer uniquement les fichiers temporaires système
- `-BrowserCache` : Nettoyer uniquement le cache des navigateurs
- `-WindowsUpdate` : Nettoyer uniquement le cache Windows Update
- `-RecycleBin` : Vider la corbeille
- `-LogFile` : Fichier de log personnalisé
- `-WhatIf` : Simulation sans effectuer les actions
- `-Force` : Forcer le nettoyage sans demander confirmation
- `-Help` : Afficher l'aide
- `-Version` : Afficher la version

**Exemples** :
```powershell
# Nettoyage complet
.\windows\powershell\system\clear-windows-cache.ps1

# Nettoyage du cache navigateur uniquement
.\windows\powershell\system\clear-windows-cache.ps1 -BrowserCache

# Simulation de nettoyage
.\windows\powershell\system\clear-windows-cache.ps1 -WhatIf

# Nettoyage forcé
.\windows\powershell\system\clear-windows-cache.ps1 -Force
```

### disable-unwanted-services.ps1
**Description** : Désactivation des services Windows non désirés

**Usage** :
```powershell
.\windows\powershell\system\disable-unwanted-services.ps1 [options]
```

**Options** :
- `-ServiceList` : Liste des services à désactiver
- `-WhatIf` : Simulation sans désactiver
- `-Force` : Forcer la désactivation
- `-Restore` : Restaurer les services désactivés
- `-Help` : Afficher l'aide
- `-Version` : Afficher la version

**Exemples** :
```powershell
# Désactivation des services par défaut
.\windows\powershell\system\disable-unwanted-services.ps1

# Simulation de désactivation
.\windows\powershell\system\disable-unwanted-services.ps1 -WhatIf

# Désactivation forcée
.\windows\powershell\system\disable-unwanted-services.ps1 -Force

# Restauration des services
.\windows\powershell\system\disable-unwanted-services.ps1 -Restore
```

### windows-update.ps1
**Description** : Mise à jour automatique de Windows

**Usage** :
```powershell
.\windows\powershell\system\windows-update.ps1 [options]
```

**Options** :
- `-CheckOnly` : Vérifier les mises à jour sans les installer
- `-InstallCritical` : Installer uniquement les mises à jour critiques
- `-InstallAll` : Installer toutes les mises à jour
- `-Restart` : Redémarrer automatiquement si nécessaire
- `-WhatIf` : Simulation sans installer
- `-Help` : Afficher l'aide
- `-Version` : Afficher la version

**Exemples** :
```powershell
# Vérifier les mises à jour disponibles
.\windows\powershell\system\windows-update.ps1 -CheckOnly

# Installer les mises à jour critiques
.\windows\powershell\system\windows-update.ps1 -InstallCritical

# Installer toutes les mises à jour
.\windows\powershell\system\windows-update.ps1 -InstallAll

# Simulation d'installation
.\windows\powershell\system\windows-update.ps1 -WhatIf
```

## 📜 Scripts Batch

### launch-dev-env.bat
**Description** : Lancement de l'environnement de développement

**Usage** :
```cmd
windows\batch\launch-dev-env.bat [options]
```

**Options** :
- `/p` : Nom du projet
- `/s` : Services à démarrer
- `/d` : Mode détaché
- `/h` : Afficher l'aide

**Exemples** :
```cmd
# Lancement de l'environnement par défaut
windows\batch\launch-dev-env.bat

# Lancement d'un projet spécifique
windows\batch\launch-dev-env.bat /p my-project

# Lancement avec services spécifiques
windows\batch\launch-dev-env.bat /s mysql,redis
```

### ping-check.bat
**Description** : Vérification de connectivité réseau

**Usage** :
```cmd
windows\batch\ping-check.bat [host] [count]
```

**Paramètres** :
- `host` : Hôte à tester (défaut: 8.8.8.8)
- `count` : Nombre de pings (défaut: 4)

**Exemples** :
```cmd
# Test de connectivité par défaut
windows\batch\ping-check.bat

# Test d'un hôte spécifique
windows\batch\ping-check.bat google.com

# Test avec 10 pings
windows\batch\ping-check.bat 192.168.1.1 10
```

### usb-backup.bat
**Description** : Sauvegarde sur périphérique USB

**Usage** :
```cmd
windows\batch\usb-backup.bat [source] [destination]
```

**Paramètres** :
- `source` : Répertoire source à sauvegarder
- `destination` : Lettre du lecteur USB (ex: D:)

**Exemples** :
```cmd
# Sauvegarde du répertoire Documents
windows\batch\usb-backup.bat C:\Users\%USERNAME%\Documents D:

# Sauvegarde d'un projet
windows\batch\usb-backup.bat C:\Projects\my-project E:
```

## 📦 Installation et Configuration

### Prérequis

#### PowerShell
```powershell
# Vérifier la version de PowerShell
$PSVersionTable.PSVersion

# Vérifier la politique d'exécution
Get-ExecutionPolicy

# Autoriser l'exécution de scripts (si nécessaire)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Outils système
```cmd
# Vérifier que les outils Windows sont disponibles
where ping
where ipconfig
where netstat
```

### Installation
```cmd
# Cloner le repository
git clone https://github.com/nythique/system-scripts.git
cd system-scripts

# Configurer les permissions (si nécessaire)
icacls windows\powershell\**\*.ps1 /grant Everyone:F
```

### Configuration PowerShell
```powershell
# Créer un profil PowerShell personnalisé
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

# Ajouter des alias pour les scripts
Add-Content -Path $PROFILE -Value @"
# Aliases pour System-Scripts
Set-Alias -Name Clear-Cache -Value ".\windows\powershell\system\clear-windows-cache.ps1"
Set-Alias -Name Update-Windows -Value ".\windows\powershell\system\windows-update.ps1"
Set-Alias -Name Create-Users -Value ".\windows\powershell\admin\create-users-bulk.ps1"
"@
```

## 🚀 Utilisation

### Exécution directe
```powershell
# Exécuter un script PowerShell
.\windows\powershell\system\clear-windows-cache.ps1

# Avec options
.\windows\powershell\system\clear-windows-cache.ps1 -WhatIf -Force
```

### Via des alias (après configuration)
```powershell
# Utiliser les alias configurés
Clear-Cache -WhatIf
Update-Windows -CheckOnly
Create-Users -CsvFile "users.csv"
```

### Via des raccourcis
```cmd
# Créer des raccourcis pour un accès facile
powershell -Command "& '.\windows\powershell\system\clear-windows-cache.ps1' -WhatIf"
```

### Via des tâches planifiées
```powershell
# Créer une tâche planifiée pour le nettoyage de cache
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File 'C:\path\to\clear-windows-cache.ps1' -All"
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 2am
Register-ScheduledTask -TaskName "Clear Windows Cache" -Action $action -Trigger $trigger
```

## 🧪 Tests

### Exécuter les tests
```powershell
# Tests unitaires et d'intégration
.\tests\run-all-tests.sh

# Tests spécifiques à Windows
.\tests\run-all-tests.sh --script windows/powershell/system/clear-windows-cache.ps1
```

### Tests manuels PowerShell
```powershell
# Test de syntaxe
powershell -Command "Get-Command '.\windows\powershell\system\clear-windows-cache.ps1'"

# Test d'aide
.\windows\powershell\system\clear-windows-cache.ps1 -Help

# Test de version
.\windows\powershell\system\clear-windows-cache.ps1 -Version
```

### Tests manuels Batch
```cmd
# Test de syntaxe
cmd /c "windows\batch\ping-check.bat"

# Test avec paramètres
cmd /c "windows\batch\ping-check.bat google.com 2"
```

## 📝 Logs et Debugging

### Fichiers de log
- `%TEMP%\cache-cleanup.log` : Logs de nettoyage de cache
- `%TEMP%\windows-update.log` : Logs de mise à jour Windows
- `%TEMP%\user-creation.log` : Logs de création d'utilisateurs

### Mode debug PowerShell
```powershell
# Activer le mode debug
$VerbosePreference = "Continue"
.\windows\powershell\system\clear-windows-cache.ps1 -Verbose

# Afficher les variables d'environnement
Get-ChildItem Env: | Where-Object {$_.Name -like "*SCRIPT*"}
```

### Mode debug Batch
```cmd
# Activer l'écho des commandes
@echo on
windows\batch\ping-check.bat

# Désactiver l'écho
@echo off
```

## 🔧 Personnalisation

### Variables d'environnement
```powershell
# Configuration des scripts
$env:SCRIPT_LOG_DIR = "C:\Logs\SystemScripts"
$env:SCRIPT_BACKUP_DIR = "D:\Backups"
$env:SCRIPT_EMAIL = "admin@company.com"

# Persister les variables
[Environment]::SetEnvironmentVariable("SCRIPT_LOG_DIR", "C:\Logs\SystemScripts", "Machine")
```

### Fichiers de configuration
```powershell
# Configuration globale
$GlobalConfig = "C:\ProgramData\SystemScripts\config.json"

# Configuration utilisateur
$UserConfig = "$env:USERPROFILE\.system-scripts\config.json"

# Configuration projet
$ProjectConfig = ".\config\local.json"
```

### Profils PowerShell
```powershell
# Ajouter des fonctions personnalisées
function Invoke-SystemMaintenance {
    .\windows\powershell\system\clear-windows-cache.ps1 -All
    .\windows\powershell\system\windows-update.ps1 -CheckOnly
}

# Ajouter au profil
Add-Content -Path $PROFILE -Value "function Invoke-SystemMaintenance { ... }"
```

## 🆘 Dépannage

### Problèmes courants PowerShell

#### Erreur de politique d'exécution
```powershell
# Erreur: "Cannot be loaded because running scripts is disabled"
# Solution: Modifier la politique d'exécution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Erreur de signature
```powershell
# Erreur: "File cannot be loaded because it is not digitally signed"
# Solution: Autoriser l'exécution temporaire
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

#### Erreur de chemin
```powershell
# Erreur: "The term is not recognized"
# Solution: Utiliser le chemin complet
.\windows\powershell\system\clear-windows-cache.ps1
```

### Problèmes courants Batch

#### Erreur de permission
```cmd
# Erreur: "Access is denied"
# Solution: Exécuter en tant qu'administrateur
runas /user:administrator "cmd /c windows\batch\usb-backup.bat"
```

#### Erreur de chemin
```cmd
# Erreur: "The system cannot find the path specified"
# Solution: Vérifier le chemin
dir windows\batch\*.bat
```

### Obtenir de l'aide
```powershell
# Aide du script PowerShell
Get-Help .\windows\powershell\system\clear-windows-cache.ps1 -Full

# Aide du script Batch
windows\batch\launch-dev-env.bat /h

# Mode debug
.\windows\powershell\system\clear-windows-cache.ps1 -Verbose
```

## 📚 Ressources

- [Documentation PowerShell](https://docs.microsoft.com/en-us/powershell/)
- [Guide de contribution](../CONTRIBUTING.md)
- [Tests et validation](../tests/)
- [Issues et support](https://github.com/nythique/system-scripts/issues)
- [Windows Batch Commands](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands)
