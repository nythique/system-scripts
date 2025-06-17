# Scripts Unix/Linux

Collection de scripts d'automatisation système pour environnements Unix/Linux.

## 📋 Table des matières

- [Scripts de Développement](#scripts-de-développement)
- [Scripts de Sécurité](#scripts-de-sécurité)
- [Scripts Système](#scripts-système)
- [Scripts Utilitaires](#scripts-utilitaires)
- [Installation et Configuration](#installation-et-configuration)
- [Utilisation](#utilisation)
- [Tests](#tests)

## 🛠️ Scripts de Développement

### backup-project.sh
**Description** : Sauvegarde automatique de projets avec gestion des versions

**Usage** :
```bash
./unix/dev/backup-project.sh [options] <project_path>
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-v, --version` : Afficher la version
- `-d, --destination` : Répertoire de destination
- `-c, --compress` : Compresser la sauvegarde
- `-e, --exclude` : Fichiers/dossiers à exclure

**Exemples** :
```bash
# Sauvegarde simple
./unix/dev/backup-project.sh /path/to/project

# Sauvegarde compressée
./unix/dev/backup-project.sh -c -d /backups /path/to/project

# Sauvegarde avec exclusions
./unix/dev/backup-project.sh -e "node_modules,*.log" /path/to/project
```

### git-auto-commit.sh
**Description** : Commit automatique Git avec gestion intelligente des changements

**Usage** :
```bash
./unix/dev/git-auto-commit.sh [options]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-m, --message` : Message de commit personnalisé
- `-a, --all` : Commiter tous les fichiers modifiés
- `-p, --push` : Pousser automatiquement après commit

**Exemples** :
```bash
# Commit automatique
./unix/dev/git-auto-commit.sh

# Commit avec message personnalisé
./unix/dev/git-auto-commit.sh -m "Fix: correction du bug #123"

# Commit et push automatique
./unix/dev/git-auto-commit.sh -p
```

### start-dev-env.sh
**Description** : Démarrage automatique de l'environnement de développement

**Usage** :
```bash
./unix/dev/start-dev-env.sh [options]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-p, --project` : Nom du projet à démarrer
- `-s, --services` : Services spécifiques à démarrer
- `-d, --detached` : Mode détaché

**Exemples** :
```bash
# Démarrage de l'environnement par défaut
./unix/dev/start-dev-env.sh

# Démarrage d'un projet spécifique
./unix/dev/start-dev-env.sh -p my-project

# Démarrage avec services spécifiques
./unix/dev/start-dev-env.sh -s "mysql,redis,nginx"
```

## 🔒 Scripts de Sécurité

### port-scanner.sh
**Description** : Scanner de ports réseau pour audit de sécurité

**Usage** :
```bash
./unix/security/port-scanner.sh [options] <target>
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-p, --ports` : Plage de ports à scanner
- `-t, --timeout` : Timeout en secondes
- `-v, --verbose` : Mode verbeux
- `-o, --output` : Fichier de sortie

**Exemples** :
```bash
# Scan des ports communs
./unix/security/port-scanner.sh 192.168.1.1

# Scan d'une plage spécifique
./unix/security/port-scanner.sh -p "80-443" 192.168.1.1

# Scan avec sortie dans un fichier
./unix/security/port-scanner.sh -o scan_results.txt 192.168.1.1
```

### ssh-key-check.sh
**Description** : Vérification et audit des clés SSH

**Usage** :
```bash
./unix/security/ssh-key-check.sh [options]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-u, --user` : Utilisateur spécifique
- `-d, --directory` : Répertoire des clés
- `-v, --validate` : Valider les clés
- `-r, --report` : Générer un rapport

**Exemples** :
```bash
# Vérification des clés de l'utilisateur courant
./unix/security/ssh-key-check.sh

# Vérification d'un utilisateur spécifique
./unix/security/ssh-key-check.sh -u admin

# Validation complète avec rapport
./unix/security/ssh-key-check.sh -v -r
```

## ⚙️ Scripts Système

### monitor-disk-space.sh
**Description** : Surveillance d'espace disque avec alertes configurables

**Usage** :
```bash
./unix/system/monitor-disk-space.sh [options] [mount_point]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-v, --version` : Afficher la version
- `-t, --threshold` : Seuil d'alerte en pourcentage (défaut: 80)
- `-c, --critical` : Seuil critique en pourcentage (défaut: 90)
- `-e, --email` : Adresse email pour les alertes
- `-d, --debug` : Mode debug
- `-l, --log` : Fichier de log personnalisé

**Exemples** :
```bash
# Surveillance de tous les systèmes de fichiers
./unix/system/monitor-disk-space.sh

# Surveillance avec seuils personnalisés
./unix/system/monitor-disk-space.sh -t 85 -c 95

# Surveillance avec alertes email
./unix/system/monitor-disk-space.sh -e admin@example.com

# Surveillance d'un point de montage spécifique
./unix/system/monitor-disk-space.sh /home
```

### update-system.sh
**Description** : Mise à jour automatique du système selon la distribution

**Usage** :
```bash
./unix/system/update-system.sh [options]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-v, --version` : Afficher la version
- `-c, --check` : Vérifier les mises à jour sans les installer
- `-f, --force` : Forcer la mise à jour sans confirmation
- `-s, --security` : Mettre à jour uniquement les paquets de sécurité
- `-d, --dry-run` : Simulation sans effectuer les mises à jour
- `-l, --log` : Fichier de log personnalisé

**Distributions supportées** :
- Ubuntu/Debian (apt)
- CentOS/RHEL/Fedora (yum/dnf)
- Arch Linux (pacman)
- Alpine Linux (apk)
- openSUSE (zypper)

**Exemples** :
```bash
# Vérifier les mises à jour disponibles
./unix/system/update-system.sh --check

# Mise à jour complète
./unix/system/update-system.sh

# Mise à jour de sécurité uniquement
./unix/system/update-system.sh --security

# Simulation de mise à jour
./unix/system/update-system.sh --dry-run
```

### cleanup-temp.sh
**Description** : Nettoyage des fichiers temporaires système

**Usage** :
```bash
./unix/system/cleanup-temp.sh [options]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-a, --all` : Nettoyer tous les répertoires temporaires
- `-o, --older-than` : Supprimer les fichiers plus vieux que X jours
- `-s, --size` : Supprimer les fichiers plus gros que X MB
- `-d, --dry-run` : Simulation sans supprimer

**Exemples** :
```bash
# Nettoyage standard
./unix/system/cleanup-temp.sh

# Nettoyage complet
./unix/system/cleanup-temp.sh --all

# Supprimer les fichiers de plus de 7 jours
./unix/system/cleanup-temp.sh --older-than 7

# Simulation de nettoyage
./unix/system/cleanup-temp.sh --dry-run
```

### cron-health-check.sh
**Description** : Vérification de la santé du système cron

**Usage** :
```bash
./unix/system/cron-health-check.sh [options]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-u, --user` : Vérifier un utilisateur spécifique
- `-v, --verbose` : Mode verbeux
- `-r, --repair` : Tenter de réparer les problèmes
- `-o, --output` : Fichier de sortie

**Exemples** :
```bash
# Vérification générale
./unix/system/cron-health-check.sh

# Vérification d'un utilisateur
./unix/system/cron-health-check.sh -u www-data

# Vérification avec réparation
./unix/system/cron-health-check.sh --repair
```

## 🛠️ Scripts Utilitaires

### battery-alert.sh
**Description** : Alerte de batterie pour ordinateurs portables

**Usage** :
```bash
./unix/original/battery-alert.sh [options]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-t, --threshold` : Seuil d'alerte en pourcentage (défaut: 20)
- `-i, --interval` : Intervalle de vérification en secondes
- `-n, --notify` : Utiliser les notifications système
- `-s, --sound` : Jouer un son d'alerte

**Exemples** :
```bash
# Alerte standard (20%)
./unix/original/battery-alert.sh

# Alerte à 15% avec vérification toutes les 30 secondes
./unix/original/battery-alert.sh -t 15 -i 30

# Alerte avec notification et son
./unix/original/battery-alert.sh -n -s
```

### generate-password.sh
**Description** : Générateur de mots de passe sécurisés

**Usage** :
```bash
./unix/original/generate-password.sh [options]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-l, --length` : Longueur du mot de passe (défaut: 16)
- `-c, --complexity` : Niveau de complexité (1-4)
- `-n, --numbers` : Inclure des chiffres
- `-s, --symbols` : Inclure des symboles
- `-u, --uppercase` : Inclure des majuscules

**Exemples** :
```bash
# Mot de passe standard (16 caractères)
./unix/original/generate-password.sh

# Mot de passe de 20 caractères
./unix/original/generate-password.sh -l 20

# Mot de passe complexe
./unix/original/generate-password.sh -c 4 -s -u
```

### slow-internet-detector.sh
**Description** : Détecteur de connexion internet lente

**Usage** :
```bash
./unix/original/slow-internet-detector.sh [options]
```

**Options** :
- `-h, --help` : Afficher l'aide
- `-t, --threshold` : Seuil de vitesse en Mbps
- `-i, --interval` : Intervalle de test en secondes
- `-c, --count` : Nombre de tests à effectuer
- `-o, --output` : Fichier de sortie

**Exemples** :
```bash
# Test de vitesse standard
./unix/original/slow-internet-detector.sh

# Test avec seuil personnalisé
./unix/original/slow-internet-detector.sh -t 10

# Test continu toutes les 5 minutes
./unix/original/slow-internet-detector.sh -i 300
```

## 📦 Installation et Configuration

### Prérequis
```bash
# Vérifier que bash est installé
bash --version

# Vérifier les permissions
ls -la unix/**/*.sh
```

### Installation
```bash
# Cloner le repository
git clone https://github.com/nythique/system-scripts.git
cd system-scripts

# Configurer les permissions
chmod +x unix/**/*.sh

# Ou utiliser le script automatique
./setup-permissions.sh --force
```

### Configuration
```bash
# Créer un fichier de configuration personnalisé
cp unix/config.example unix/config.local

# Éditer la configuration
nano unix/config.local
```

## 🚀 Utilisation

### Exécution directe
```bash
# Exécuter un script directement
./unix/system/monitor-disk-space.sh

# Avec options
./unix/system/monitor-disk-space.sh -t 85 -e admin@example.com
```

### Via des liens symboliques
```bash
# Créer des liens pour un accès facile
sudo ln -s $(pwd)/unix/system/monitor-disk-space.sh /usr/local/bin/disk-monitor
sudo ln -s $(pwd)/unix/system/update-system.sh /usr/local/bin/system-update

# Utilisation
disk-monitor
system-update --check
```

### Via cron
```bash
# Éditer le crontab
crontab -e

# Ajouter des tâches
# Surveillance disque toutes les heures
0 * * * * /path/to/system-scripts/unix/system/monitor-disk-space.sh -t 85 -e admin@example.com

# Mise à jour système quotidienne
0 2 * * * /path/to/system-scripts/unix/system/update-system.sh --security
```

## 🧪 Tests

### Exécuter tous les tests
```bash
# Tests unitaires et d'intégration
./tests/run-all-tests.sh

# Tests unitaires uniquement
./tests/run-all-tests.sh --unit

# Tests d'intégration uniquement
./tests/run-all-tests.sh --integration
```

### Tester un script spécifique
```bash
# Test d'un script spécifique
./tests/run-all-tests.sh --script unix/system/monitor-disk-space.sh

# Test unitaire spécifique
./tests/unit/test-monitor-disk-space.sh
```

### Tests manuels
```bash
# Test de syntaxe
bash -n unix/system/monitor-disk-space.sh

# Test d'aide
./unix/system/monitor-disk-space.sh --help

# Test de version
./unix/system/monitor-disk-space.sh --version
```

## 📝 Logs et Debugging

### Fichiers de log
- `/var/log/disk-monitor.log` : Logs de surveillance disque
- `/var/log/system-update.log` : Logs de mise à jour système
- `/tmp/script-name.log` : Logs temporaires

### Mode debug
```bash
# Activer le mode debug
./unix/system/monitor-disk-space.sh --debug

# Afficher les variables d'environnement
env | grep SCRIPT
```

## 🔧 Personnalisation

### Variables d'environnement
```bash
# Seuils par défaut
export DISK_WARNING_THRESHOLD=80
export DISK_CRITICAL_THRESHOLD=90

# Email d'alerte
export ALERT_EMAIL=admin@example.com

# Répertoire de logs
export LOG_DIR=/var/log/system-scripts
```

### Fichiers de configuration
```bash
# Configuration globale
/etc/system-scripts/config.conf

# Configuration utilisateur
~/.config/system-scripts/config.conf

# Configuration projet
./config/local.conf
```

## 🆘 Dépannage

### Problèmes courants
1. **Permission denied** : Vérifier les permissions avec `ls -la`
2. **Command not found** : Vérifier que bash est installé
3. **Log file not writable** : Vérifier les permissions du répertoire de logs

### Obtenir de l'aide
```bash
# Aide du script
./unix/system/monitor-disk-space.sh --help

# Version du script
./unix/system/monitor-disk-space.sh --version

# Mode debug
./unix/system/monitor-disk-space.sh --debug
```

## 📚 Ressources

- [Documentation Bash](https://www.gnu.org/software/bash/manual/)
- [Guide de contribution](../CONTRIBUTING.md)
- [Tests et validation](../tests/)
- [Issues et support](https://github.com/nythique/system-scripts/issues)
