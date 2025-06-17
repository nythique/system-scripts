
# System-Scripts
> 🇫🇷 **Version française** | [🇺🇸 English version](README_EN.md)

Une collection complète de scripts d'automatisation système pour Unix, Windows et plateformes croisées.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Unix%20%7C%20Windows%20%7C%20Cross--platform-blue.svg)](https://github.com/nythique/system-scripts)


## 📋 Table des matières

- [Fonctionnalités](#-fonctionnalités)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Scripts disponibles](#-scripts-disponibles)
- [Contribuer](#-contribuer)
- [Licence](#-licence)

## ✨ Fonctionnalités

- **Multi-plateforme** : Scripts pour Unix/Linux, Windows et plateformes croisées
- **Automatisation système** : Surveillance, maintenance et administration
- **Sécurité** : Outils de sécurité et d'audit
- **Développement** : Scripts pour l'environnement de développement
- **Administration** : Gestion des utilisateurs et des systèmes

## 🚀 Installation

### Prérequis

#### Pour Unix/Linux :
```bash
# Vérifier que bash est installé
bash --version

# Rendre les scripts exécutables
chmod +x unix/**/*.sh
chmod +x cross-platform/*.sh
```

#### Pour Windows :
```powershell
# Vérifier la politique d'exécution PowerShell
Get-ExecutionPolicy

# Si nécessaire, autoriser l'exécution de scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Installation rapide

1. **Cloner le repository** :
```bash
git clone https://github.com/nythique/system-scripts.git
cd system-scripts
```

2. **Configurer les permissions** (Unix/Linux) :
```bash
# Rendre tous les scripts exécutables
find . -name "*.sh" -exec chmod +x {} \;
```

3. **Tester l'installation** :
```bash
# Unix/Linux
./unix/system/monitor-disk-space.sh

# Windows PowerShell
.\windows\powershell\system\windows-update.ps1
```

## 📖 Utilisation

### Scripts Unix/Linux

#### Surveillance système
```bash
# Surveiller l'espace disque
./unix/system/monitor-disk-space.sh

# Nettoyer les fichiers temporaires
./unix/system/cleanup-temp.sh

# Vérifier la santé du système cron
./unix/system/cron-health-check.sh
```

#### Sécurité
```bash
# Scanner les ports ouverts
./unix/security/port-scanner.sh

# Vérifier les clés SSH
./unix/security/ssh-key-check.sh
```

#### Développement
```bash
# Sauvegarder un projet
./unix/dev/backup-project.sh

# Commit automatique Git
./unix/dev/git-auto-commit.sh

# Démarrer l'environnement de développement
./unix/dev/start-dev-env.sh
```

### Scripts Windows

#### PowerShell - Administration
```powershell
# Créer des utilisateurs en masse
.\windows\powershell\admin\create-users-bulk.ps1 -CsvFile "users.csv"

# Exporter la liste des logiciels installés
.\windows\powershell\admin\export-installed-software.ps1
```

#### PowerShell - Système
```powershell
# Nettoyer le cache Windows
.\windows\powershell\system\clear-windows-cache.ps1

# Désactiver les services non désirés
.\windows\powershell\system\disable-unwanted-services.ps1

# Mettre à jour Windows
.\windows\powershell\system\windows-update.ps1
```

#### Batch
```cmd
# Vérifier la connectivité réseau
windows\batch\ping-check.bat

# Sauvegarder sur USB
windows\batch\usb-backup.bat D: C:\backup

# Lancer l'environnement de développement
windows\batch\launch-dev-env.bat
```

### Scripts Cross-platform

```bash
# Vérifier le statut réseau
./cross-platform/check-network-status.sh

# Sauvegarde quotidienne
./cross-platform/daily-backup.sh /source /destination

# Synchroniser des dossiers
./cross-platform/sync-folders.sh /source /destination
```


## 🔧 Scripts disponibles

### Unix/Linux Scripts

#### Dev Operations
- `backup-project.sh` - Sauvegarde automatique de projets
- `git-auto-commit.sh` - Commit automatique Git
- `start-dev-env.sh` - Démarrage environnement de développement

#### Security Operations
- `port-scanner.sh` - Scanner de ports réseau
- `ssh-key-check.sh` - Vérification des clés SSH

#### System Operations
- `cleanup-temp.sh` - Nettoyage des fichiers temporaires
- `cron-health-check.sh` - Vérification de la santé cron
- `monitor-disk-space.sh` - Surveillance de l'espace disque
- `update-system.sh` - Mise à jour du système

#### Original Operations
- `battery-alert.sh` - Alerte de batterie
- `generate-password.sh` - Générateur de mots de passe
- `slow-internet-detector.sh` - Détecteur de connexion lente

### Windows Scripts

#### PowerShell Admin
- `create-users-bulk.ps1` - Création d'utilisateurs en masse
- `export-installed-software.ps1` - Export des logiciels installés

#### PowerShell System
- `clear-windows-cache.ps1` - Nettoyage du cache Windows
- `disable-unwanted-services.ps1` - Désactivation de services
- `windows-update.ps1` - Mise à jour Windows

#### Batch Scripts
- `launch-dev-env.bat` - Lancement environnement de développement
- `ping-check.bat` - Vérification de connectivité
- `usb-backup.bat` - Sauvegarde sur USB

### Cross-platform Scripts
- `check-network-status.sh` - Vérification du statut réseau
- `daily-backup.sh` - Sauvegarde quotidienne
- `sync-folders.sh` - Synchronisation de dossiers

## 🤝 Contribuer

Nous accueillons les contributions ! Consultez notre [guide de contribution](CONTRIBUTING.md) pour plus de détails.

### Comment contribuer

1. Fork le projet
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

### Standards de code

- Utilisez des commentaires descriptifs
- Suivez les conventions de nommage
- Testez vos scripts avant de soumettre
- Documentez les nouvelles fonctionnalités

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- Merci à tous les contributeurs
- Inspiré par des pratiques d'automatisation système
- Support de la communauté open source

## 👥 Contributeurs

<a href="https://github.com/nythique/system-scripts/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=nythique/system-scripts" />
</a>

---

Si vous rencontrez des problèmes :

- Ouvrez une [issue](https://github.com/nythique/system-scripts/issues)
- N'hésitez pas à contribuer 
