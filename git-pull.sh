#!/bin/bash
# ===================================================================
# ⬇️ SCRIPT PULL RAPIDO - SeasonVale  
# ===================================================================
# Automatizza il processo: pull + controllo conflitti
# Uso: ./git-pull.sh

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎮 SeasonVale - Pull automatico${NC}"
echo "=================================="

echo -e "${BLUE}⬇️ Scaricando ultime modifiche da GitHub...${NC}"
git pull

# Controlla il risultato del pull
RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ SUCCESSO! Progetto aggiornato${NC}"
    echo -e "${GREEN}🎯 Puoi ora aprire GameMaker e lavorare${NC}"
else
    echo ""
    echo -e "${RED}❌ PROBLEMI durante il pull!${NC}"
    echo ""
    echo -e "${YELLOW}🔧 Possibili cause:${NC}"
    echo "1. Conflitti di merge (file modificati su entrambi i computer)"
    echo "2. Connessione internet non disponibile"
    echo "3. Repository remoto non raggiungibile"
    echo ""
    echo -e "${YELLOW}💡 Soluzioni:${NC}"
    echo "• Per conflitti: usa 'git status' per vedere i file in conflitto"
    echo "• Modifica i file manualmente e poi 'git add .' + 'git commit'"
    echo "• O chiedi aiuto per risolvere i conflitti"
fi

echo ""