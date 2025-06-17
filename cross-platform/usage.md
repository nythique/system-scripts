# Scripts Cross-Platform

Collection de scripts d'automatisation système fonctionnant sur plusieurs plateformes.

## 📋 Table des matières

- [Scripts Disponibles](#scripts-disponibles)
- [Installation et Configuration](#installation-et-configuration)
- [Utilisation](#utilisation)
- [Tests](#tests)
- [Dépannage](#dépannage)

## 🔧 Scripts Disponibles

### check-network-status.sh
**Description** : Vérification du statut réseau et de la connectivité

**Usage** :
```bash
./cross-platform/check-network-status.sh [options]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-v, --version` : Afficher la version
- `-t, --timeout` : Timeout en secondes (défaut: 5)
- `-r, --retries` : Nombre de tentatives (défaut: 3)
- `-o, --output` : Fichier de sortie
- `-d, --debug` : Mode debug

**Fonctionnalités** :
- Test de connectivité Internet
- Vérification des serveurs DNS
- Test de latence
- Vérification des ports communs
- Rapport détaillé

**Exemples** :
```bash
# Vérification standard
./cross-platform/check-network-status.sh

# Vérification avec timeout personnalisé
./cross-platform/check-network-status.sh -t 10

# Vérification avec sortie dans un fichier
./cross-platform/check-network-status.sh -o network-report.txt

# Mode debug
./cross-platform/check-network-status.sh -d
```

### daily-backup.sh
**Description** : Sauvegarde quotidienne automatique avec rotation

**Usage** :
```bash
./cross-platform/daily-backup.sh [options] <source> <destination>
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-v, --version` : Afficher la version
- `-c, --compress` : Compresser les sauvegardes
- `-e, --exclude` : Fichiers/dossiers à exclure
- `-r, --retention` : Nombre de jours de rétention (défaut: 7)
- `-l, --log` : Fichier de log personnalisé
- `-d, --dry-run` : Simulation sans effectuer la sauvegarde

**Fonctionnalités** :
- Sauvegarde incrémentale
- Rotation automatique des sauvegardes
- Compression optionnelle
- Exclusion de fichiers
- Logging détaillé
- Vérification d'intégrité

**Exemples** :
```bash
# Sauvegarde simple
./cross-platform/daily-backup.sh /home/user /backup

# Sauvegarde compressée avec rétention de 30 jours
./cross-platform/daily-backup.sh -c -r 30 /home/user /backup

# Sauvegarde avec exclusions
./cross-platform/daily-backup.sh -e "*.tmp,*.log" /home/user /backup

# Simulation de sauvegarde
./cross-platform/daily-backup.sh -d /home/user /backup
```

### sync-folders.sh
**Description** : Synchronisation bidirectionnelle de dossiers

**Usage** :
```bash
./cross-platform/sync-folders.sh [options] <source> <destination>
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-v, --version` : Afficher la version
- `-b, --bidirectional` : Synchronisation bidirectionnelle
- `-e, --exclude` : Fichiers/dossiers à exclure
- `-d, --delete` : Supprimer les fichiers orphelins
- `-l, --log` : Fichier de log personnalisé
- `-n, --dry-run` : Simulation sans synchroniser
- `-w, --watch` : Mode surveillance continue

**Fonctionnalités** :
- Synchronisation unidirectionnelle ou bidirectionnelle
- Exclusion de fichiers
- Suppression optionnelle des fichiers orphelins
- Mode surveillance continue
- Logging détaillé
- Vérification des conflits

**Exemples** :
```bash
# Synchronisation simple
./cross-platform/sync-folders.sh /source /destination

# Synchronisation bidirectionnelle
./cross-platform/sync-folders.sh -b /source /destination

# Synchronisation avec exclusions et suppression
./cross-platform/sync-folders.sh -e "*.tmp" -d /source /destination

# Mode surveillance continue
./cross-platform/sync-folders.sh -w /source /destination

# Simulation de synchronisation
./cross-platform/sync-folders.sh -n /source /destination
```

## 📦 Installation et Configuration

### Prérequis

#### Outils système requis
```bash
# Vérifier la disponibilité des outils
command -v rsync >/dev/null 2>&1 || echo "rsync non trouvé"
command -v curl >/dev/null 2>&1 || echo "curl non trouvé"
command -v ping >/dev/null 2>&1 || echo "ping non trouvé"
command -v nc >/dev/null 2>&1 || echo "netcat non trouvé"
```

#### Installation des dépendances

**Ubuntu/Debian** :
```bash
sudo apt update
sudo apt install rsync curl netcat-openbsd
```

**CentOS/RHEL/Fedora** :
```bash
sudo yum install rsync curl nc
# ou
sudo dnf install rsync curl nc
```

**macOS** :
```bash
# rsync est inclus par défaut
brew install curl netcat
```

**Windows (avec WSL ou Git Bash)** :
```bash
# rsync est généralement disponible avec WSL
# ou installer via Cygwin
```

### Installation des scripts
```bash
# Cloner le repository
git clone https://github.com/nythique/system-scripts.git
cd system-scripts

# Rendre les scripts exécutables
chmod +x cross-platform/*.sh

# Ou utiliser le script automatique
./setup-permissions.sh --force
```

### Configuration
```bash
# Créer un fichier de configuration
cat > cross-platform/config.conf << EOF
# Configuration des scripts cross-platform
BACKUP_RETENTION_DAYS=7
SYNC_EXCLUDE_PATTERNS="*.tmp,*.log,*.cache"
NETWORK_TIMEOUT=10
LOG_DIR="/var/log/system-scripts"
EOF
```

## 🚀 Utilisation

### Exécution directe
```bash
# Vérification réseau
./cross-platform/check-network-status.sh

# Sauvegarde quotidienne
./cross-platform/daily-backup.sh /home/user /backup

# Synchronisation de dossiers
./cross-platform/sync-folders.sh /source /destination
```

### Via des liens symboliques
```bash
# Créer des liens pour un accès facile
sudo ln -s $(pwd)/cross-platform/check-network-status.sh /usr/local/bin/network-check
sudo ln -s $(pwd)/cross-platform/daily-backup.sh /usr/local/bin/daily-backup
sudo ln -s $(pwd)/cross-platform/sync-folders.sh /usr/local/bin/sync-folders

# Utilisation
network-check
daily-backup /home/user /backup
sync-folders /source /destination
```

### Via cron (Linux/macOS)
```bash
# Éditer le crontab
crontab -e

# Ajouter des tâches
# Vérification réseau toutes les heures
0 * * * * /path/to/system-scripts/cross-platform/check-network-status.sh

# Sauvegarde quotidienne à 2h du matin
0 2 * * * /path/to/system-scripts/cross-platform/daily-backup.sh /home/user /backup

# Synchronisation toutes les 30 minutes
*/30 * * * * /path/to/system-scripts/cross-platform/sync-folders.sh /source /destination
```

### Via Task Scheduler (Windows)
```cmd
# Créer une tâche planifiée pour la vérification réseau
schtasks /create /tn "Network Check" /tr "C:\path\to\check-network-status.sh" /sc hourly

# Créer une tâche pour la sauvegarde quotidienne
schtasks /create /tn "Daily Backup" /tr "C:\path\to\daily-backup.sh C:\Users D:\Backup" /sc daily /st 02:00
```

## 🧪 Tests

### Exécuter les tests
```bash
# Tests unitaires et d'intégration
./tests/run-all-tests.sh

# Tests spécifiques aux scripts cross-platform
./tests/run-all-tests.sh --script cross-platform/check-network-status.sh
```

### Tests manuels
```bash
# Test de syntaxe
bash -n cross-platform/check-network-status.sh

# Test d'aide
./cross-platform/check-network-status.sh --help

# Test de version
./cross-platform/check-network-status.sh --version

# Test de connectivité
./cross-platform/check-network-status.sh -t 5
```

### Tests de sauvegarde
```bash
# Créer des données de test
mkdir -p /tmp/test-source
echo "test data" > /tmp/test-source/test.txt

# Test de sauvegarde
./cross-platform/daily-backup.sh -d /tmp/test-source /tmp/test-backup

# Vérifier le résultat
ls -la /tmp/test-backup
```

### Tests de synchronisation
```bash
# Créer des dossiers de test
mkdir -p /tmp/source /tmp/destination
echo "source data" > /tmp/source/file1.txt
echo "destination data" > /tmp/destination/file2.txt

# Test de synchronisation
./cross-platform/sync-folders.sh -n /tmp/source /tmp/destination

# Synchronisation réelle
./cross-platform/sync-folders.sh /tmp/source /tmp/destination
```

## 📝 Logs et Debugging

### Fichiers de log
- `/var/log/system-scripts/network-check.log` : Logs de vérification réseau
- `/var/log/system-scripts/daily-backup.log` : Logs de sauvegarde
- `/var/log/system-scripts/sync-folders.log` : Logs de synchronisation

### Mode debug
```bash
# Activer le mode debug pour tous les scripts
export DEBUG=true

# Ou utiliser l'option -d
./cross-platform/check-network-status.sh -d
./cross-platform/daily-backup.sh -d /source /destination
./cross-platform/sync-folders.sh -d /source /destination
```

### Variables d'environnement utiles
```bash
# Configuration des timeouts
export NETWORK_TIMEOUT=15
export BACKUP_TIMEOUT=300

# Configuration des logs
export LOG_LEVEL=DEBUG
export LOG_FILE="/var/log/system-scripts/cross-platform.log"

# Configuration des exclusions
export SYNC_EXCLUDE="*.tmp,*.log,*.cache"
export BACKUP_EXCLUDE="node_modules,*.git"
```

## 🔧 Personnalisation

### Configuration avancée
```bash
# Créer un fichier de configuration personnalisé
cat > cross-platform/local.conf << EOF
# Configuration personnalisée
NETWORK_HOSTS="8.8.8.8,1.1.1.1,google.com"
BACKUP_COMPRESSION=true
BACKUP_RETENTION_DAYS=30
SYNC_BIDIRECTIONAL=true
SYNC_DELETE_ORPHANED=false
LOG_VERBOSE=true
EOF

# Charger la configuration
source cross-platform/local.conf
```

### Scripts personnalisés
```bash
# Créer un script de maintenance personnalisé
cat > maintenance.sh << 'EOF'
#!/bin/bash
# Script de maintenance personnalisé

echo "=== Maintenance système ==="

# Vérification réseau
./cross-platform/check-network-status.sh

# Sauvegarde des données importantes
./cross-platform/daily-backup.sh /home/user /backup

# Synchronisation des dossiers de travail
./cross-platform/sync-folders.sh /work /backup/work

echo "=== Maintenance terminée ==="
EOF

chmod +x maintenance.sh
```

### Intégration avec d'autres outils
```bash
# Intégration avec systemd (Linux)
cat > /etc/systemd/system/network-monitor.service << EOF
[Unit]
Description=Network Status Monitor
After=network.target

[Service]
Type=oneshot
ExecStart=/path/to/system-scripts/cross-platform/check-network-status.sh
User=root

[Install]
WantedBy=multi-user.target
EOF

# Activer le service
systemctl enable network-monitor.service
```

## 🆘 Dépannage

### Problèmes courants

#### Erreur de permission
```bash
# Erreur: "Permission denied"
# Solution: Vérifier les permissions
ls -la cross-platform/*.sh
chmod +x cross-platform/*.sh
```

#### Erreur de dépendance
```bash
# Erreur: "command not found: rsync"
# Solution: Installer rsync
# Ubuntu/Debian
sudo apt install rsync

# CentOS/RHEL
sudo yum install rsync

# macOS
brew install rsync
```

#### Erreur de réseau
```bash
# Erreur: "Network unreachable"
# Solution: Vérifier la connectivité
ping -c 3 8.8.8.8
./cross-platform/check-network-status.sh -d
```

#### Erreur de synchronisation
```bash
# Erreur: "rsync failed"
# Solution: Vérifier les permissions et l'espace disque
df -h
ls -la /source /destination
./cross-platform/sync-folders.sh -n /source /destination
```

### Obtenir de l'aide
```bash
# Aide des scripts
./cross-platform/check-network-status.sh --help
./cross-platform/daily-backup.sh --help
./cross-platform/sync-folders.sh --help

# Mode debug
./cross-platform/check-network-status.sh -d
./cross-platform/daily-backup.sh -d /source /destination
./cross-platform/sync-folders.sh -d /source /destination
```

### Logs de diagnostic
```bash
# Afficher les logs récents
tail -f /var/log/system-scripts/*.log

# Rechercher les erreurs
grep -i error /var/log/system-scripts/*.log

# Analyser les performances
grep "duration\|time" /var/log/system-scripts/*.log
```

## 📚 Ressources

- [Documentation rsync](https://rsync.samba.org/documentation.html)
- [Guide de contribution](../CONTRIBUTING.md)
- [Tests et validation](../tests/)
- [Issues et support](https://github.com/nythique/system-scripts/issues)
- [Cross-platform scripting best practices](https://en.wikipedia.org/wiki/Cross-platform)

