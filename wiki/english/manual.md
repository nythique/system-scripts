# System-Scripts

A comprehensive collection of system automation scripts for Unix, Windows, and cross-platform environments.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Unix%20%7C%20Windows%20%7C%20Cross--platform-blue.svg)](https://github.com/nythique/system-scripts)

> 🇺🇸 **English version** | [🇫🇷 Version française](README.md)

## 📋 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Usage](#-usage)
- [Available Scripts](#-available-scripts)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

- **Multi-platform**: Scripts for Unix/Linux, Windows, and cross-platform environments
- **System Automation**: Monitoring, maintenance, and administration
- **Security**: Security and audit tools
- **Development**: Scripts for development environment
- **Administration**: User and system management

## 🚀 Installation

### Prerequisites

#### For Unix/Linux:
```bash
# Check if bash is installed
bash --version

# Make scripts executable
chmod +x unix/**/*.sh
chmod +x cross-platform/*.sh
```

#### For Windows:
```powershell
# Check PowerShell execution policy
Get-ExecutionPolicy

# If needed, allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Quick Installation

1. **Clone the repository**:
```bash
git clone https://github.com/nythique/system-scripts.git
cd system-scripts
```

2. **Set permissions** (Unix/Linux):
```bash
# Make all scripts executable
find . -name "*.sh" -exec chmod +x {} \;
```

3. **Test installation**:
```bash
# Unix/Linux
./unix/system/monitor-disk-space.sh

# Windows PowerShell
.\windows\powershell\system\windows-update.ps1
```

## 📖 Usage

### Unix/Linux Scripts

#### System Monitoring
```bash
# Monitor disk space
./unix/system/monitor-disk-space.sh

# Clean temporary files
./unix/system/cleanup-temp.sh

# Check cron system health
./unix/system/cron-health-check.sh
```

#### Security
```bash
# Scan open ports
./unix/security/port-scanner.sh

# Check SSH keys
./unix/security/ssh-key-check.sh
```

#### Development
```bash
# Backup a project
./unix/dev/backup-project.sh

# Auto Git commit
./unix/dev/git-auto-commit.sh

# Start development environment
./unix/dev/start-dev-env.sh
```

### Windows Scripts

#### PowerShell - Administration
```powershell
# Create users in bulk
.\windows\powershell\admin\create-users-bulk.ps1 -CsvFile "users.csv"

# Export installed software list
.\windows\powershell\admin\export-installed-software.ps1
```

#### PowerShell - System
```powershell
# Clear Windows cache
.\windows\powershell\system\clear-windows-cache.ps1

# Disable unwanted services
.\windows\powershell\system\disable-unwanted-services.ps1

# Update Windows
.\windows\powershell\system\windows-update.ps1
```

#### Batch
```cmd
# Check network connectivity
windows\batch\ping-check.bat

# Backup to USB
windows\batch\usb-backup.bat D: C:\backup

# Launch development environment
windows\batch\launch-dev-env.bat
```

### Cross-platform Scripts

```bash
# Check network status
./cross-platform/check-network-status.sh

# Daily backup
./cross-platform/daily-backup.sh /source /destination

# Sync folders
./cross-platform/sync-folders.sh /source /destination
```

## 🔧 Available Scripts

### Unix/Linux Scripts

#### Dev Operations
- `backup-project.sh` - Automatic project backup
- `git-auto-commit.sh` - Automatic Git commit
- `start-dev-env.sh` - Development environment startup

#### Security Operations
- `port-scanner.sh` - Network port scanner
- `ssh-key-check.sh` - SSH key verification

#### System Operations
- `cleanup-temp.sh` - Temporary files cleanup
- `cron-health-check.sh` - Cron system health check
- `monitor-disk-space.sh` - Disk space monitoring
- `update-system.sh` - System update

#### Original Operations
- `battery-alert.sh` - Battery alert
- `generate-password.sh` - Password generator
- `slow-internet-detector.sh` - Slow connection detector

### Windows Scripts

#### PowerShell Admin
- `create-users-bulk.ps1` - Bulk user creation
- `export-installed-software.ps1` - Installed software export

#### PowerShell System
- `clear-windows-cache.ps1` - Windows cache cleanup
- `disable-unwanted-services.ps1` - Service disabling
- `windows-update.ps1` - Windows update

#### Batch Scripts
- `launch-dev-env.bat` - Development environment launch
- `ping-check.bat` - Connectivity check
- `usb-backup.bat` - USB backup

### Cross-platform Scripts
- `check-network-status.sh` - Network status check
- `daily-backup.sh` - Daily backup
- `sync-folders.sh` - Folder synchronization

## 🤝 Contributing

We welcome contributions! Check our [contributing guide](CONTRIBUTING.md) for more details.

### How to contribute

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code standards

- Use descriptive comments
- Follow naming conventions
- Test your scripts before submitting
- Document new features

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Thanks to all contributors
- Inspired by system automation practices
- Open source community support

## 👥 Contributors

<a href="https://github.com/nythique/system-scripts/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=nythique/system-scripts" />
</a>


---

If you encounter any issues:

- Open an [issue](https://github.com/nythique/system-scripts/issues)
- Don't hesitate to contribute 