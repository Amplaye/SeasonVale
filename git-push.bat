@echo off
echo ================================
echo 🎮 SeasonVale - Push automatico  
echo ================================

if "%1"=="" (
    echo Errore: Inserisci un messaggio di commit!
    echo Uso: git-push.bat "Il tuo messaggio"
    echo.
    echo Esempi:
    echo git-push.bat "Aggiunto sistema farming"
    echo git-push.bat "Fix bug toolbar"
    pause
    exit /b 1
)

echo.
echo 1. Aggiungendo tutti i file...
git add .

echo 2. Creando commit: "%1"
git commit -m "%1"

echo 3. Sincronizzando con GitHub...
git push

if %ERRORLEVEL% == 0 (
    echo.
    echo SUCCESSO! Progetto sincronizzato su GitHub
    echo https://github.com/Amplaye/SeasonVale
) else (
    echo.
    echo ERRORE durante il push!
    echo Prova prima: git-pull.bat
)
echo.
pause