#!/bin/bash
# ===================================================================
# 📊 SCRIPT STATUS RAPIDO - SeasonVale
# ===================================================================
# Mostra lo stato del progetto Git in modo chiaro
# Uso: ./git-status.sh

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎮 SeasonVale - Stato Progetto${NC}"
echo "=================================="

echo -e "${PURPLE}📍 Branch attuale e commit:${NC}"
git log --oneline -3
echo ""

echo -e "${PURPLE}📝 File modificati:${NC}"
git status --porcelain

echo ""
echo -e "${PURPLE}🔄 Stato sincronizzazione:${NC}"
git status -uno

echo ""
echo -e "${YELLOW}💡 Comandi rapidi disponibili:${NC}"
echo "• ./git-pull.sh    - Scarica modifiche da GitHub"
echo "• ./git-push.sh    - Carica modifiche su GitHub"  
echo "• ./git-status.sh  - Mostra questo stato"
echo ""