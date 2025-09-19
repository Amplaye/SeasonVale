@echo off
echo ===================================
echo SINCRONIZZAZIONE COMPLETA WINDOWS
echo ===================================

echo.
echo [1] Pulizia cache GameMaker...
rd /s /q "%LOCALAPPDATA%\GameMakerStudio2\Cache" 2>nul
rd /s /q "%TEMP%\GameMakerStudio2" 2>nul

echo.
echo [2] Salvataggio stato attuale...
git add -A
git stash

echo.
echo [3] Scaricamento ultime modifiche...
git pull --rebase

echo.
echo [4] Ripristino modifiche locali...
git stash pop

echo.
echo [5] Verifica file progetto...
if exist "SeasonVale.yyp" (
    echo File progetto trovato!
) else (
    echo ERRORE: File progetto mancante!
    pause
    exit /b 1
)

echo.
echo [6] Controllo integrità sprite...
dir /b /s sprites\*.png | find /c ".png" > sprite_count.txt
set /p SPRITE_COUNT=<sprite_count.txt
del sprite_count.txt
echo Trovati %SPRITE_COUNT% file sprite

echo.
echo ===================================
echo SINCRONIZZAZIONE COMPLETATA!
echo Ora apri GameMaker e ricompila
echo ===================================
pause