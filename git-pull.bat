@echo off
echo ================================
echo SeasonVale - Pull automatico
echo ================================
echo.
echo Scaricando ultime modifiche da GitHub...
git pull

if %ERRORLEVEL% == 0 (
    echo.
    echo SUCCESSO! Progetto aggiornato
    echo Puoi ora aprire GameMaker e lavorare
) else (
    echo.
    echo PROBLEMI durante il pull!
    echo.
    echo Possibili cause:
    echo 1. Conflitti di merge
    echo 2. Connessione internet non disponibile  
    echo 3. Repository remoto non raggiungibile
)
echo.
pause