#!/bin/bash

echo "==================================="
echo "SINCRONIZZAZIONE COMPLETA MAC"
echo "==================================="

echo ""
echo "[1] Pulizia cache GameMaker..."
rm -rf ~/Library/Application\ Support/GameMakerStudio2/Cache/
rm -rf /tmp/GameMakerStudio2/

echo ""
echo "[2] Salvataggio stato attuale..."
git add -A
git stash

echo ""
echo "[3] Scaricamento ultime modifiche..."
git pull --rebase

echo ""
echo "[4] Ripristino modifiche locali..."
git stash pop || true

echo ""
echo "[5] Verifica file progetto..."
if [ -f "SeasonVale.yyp" ]; then
    echo "File progetto trovato!"
else
    echo "ERRORE: File progetto mancante!"
    exit 1
fi

echo ""
echo "[6] Controllo integrità sprite..."
SPRITE_COUNT=$(find sprites -name "*.png" 2>/dev/null | wc -l)
echo "Trovati $SPRITE_COUNT file sprite"

echo ""
echo "[7] Impostazione permessi..."
find . -name "*.gml" -exec chmod 644 {} \;
find . -name "*.yy" -exec chmod 644 {} \;
find . -name "*.yyp" -exec chmod 644 {} \;

echo ""
echo "==================================="
echo "SINCRONIZZAZIONE COMPLETATA!"
echo "Ora apri GameMaker e ricompila"
echo "==================================="