#!/bin/bash
# ===================================================================
# 🚀 SCRIPT PUSH RAPIDO - SeasonVale
# ===================================================================
# Automatizza il processo: add + commit + push
# Uso: ./git-push.sh "Il tuo messaggio di commit"

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎮 SeasonVale - Push automatico${NC}"
echo "=================================="

# Controlla se c'è un messaggio di commit
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Errore: Inserisci un messaggio di commit!${NC}"
    echo -e "${YELLOW}Uso: ./git-push.sh \"Il tuo messaggio\"${NC}"
    echo ""
    echo "Esempi:"
    echo "./git-push.sh \"Aggiunto sistema farming\""
    echo "./git-push.sh \"Fix bug toolbar\""
    echo "./git-push.sh \"Nuovi sprite e animazioni\""
    exit 1
fi

COMMIT_MSG="$1"

echo -e "${BLUE}📦 1. Aggiungendo tutti i file...${NC}"
git add .

echo -e "${BLUE}💬 2. Creando commit: ${YELLOW}\"$COMMIT_MSG\"${NC}"
git commit -m "$COMMIT_MSG"

echo -e "${BLUE}🚀 3. Sincronizzando con GitHub...${NC}"
git push

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ SUCCESSO! Progetto sincronizzato su GitHub${NC}"
    echo -e "${GREEN}🔗 https://github.com/Amplaye/SeasonVale${NC}"
else
    echo ""
    echo -e "${RED}❌ ERRORE durante il push!${NC}"
    echo -e "${YELLOW}💡 Prova prima: ./git-pull.sh${NC}"
fi

echo ""