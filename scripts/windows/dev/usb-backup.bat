@echo off

set /p usbdrive=Entrez la lettre du lecteur USB (ex: E): 

if not exist "%usbdrive%:\" (
    echo Le lecteur %usbdrive%: n'existe pas.
    pause
    exit /b
)

set backupdir=D:\Backups\USB

if not exist "%backupdir%" (
    mkdir "%backupdir%"
)

echo Sauvegarde en cours...
xcopy "%usbdrive%:\*" "%backupdir%\%usbdrive%_%date:/=-%\" /E /H /C /I /Y

echo Sauvegarde terminée.
pause