# 🎮 SeasonVale - Farming Game

## 📋 Descrizione Progetto
SeasonVale è un gioco farming sviluppato in GameMaker Studio 2 con sistema di toolbar avanzato, raccolta automatica di oggetti e meccaniche di crafting.

### ✨ Funzionalità Implementate
- **Sistema Toolbar**: 10 slot con drag & drop
- **Raccolta Magnetica**: Oggetti attratti automaticamente al player
- **Stacking Automatico**: Items dello stesso tipo si cumulano
- **Sprites Completi**: Tools, risorse e animazioni player

---

# 🔄 **WORKFLOW GIT - DUE COMPUTER**

## 🖥️ **COMPUTER 1: Prima Sessione di Lavoro**

### 1. **INIZIO LAVORO** ⬇️
```bash
cd /Users/amplaye/Downloads/SeasonVale
./git-pull.sh
```
**Cosa fa:** Scarica le ultime modifiche da GitHub prima di iniziare

### 2. **LAVORA SUL PROGETTO** 🛠️
- Apri GameMaker Studio 2
- Apri `SeasonVale.yyp` 
- Fai le tue modifiche (codice, sprite, oggetti, ecc.)
- Testa il gioco

### 3. **FINE SESSIONE** ⬆️
```bash
./git-push.sh "Descrizione delle modifiche fatte"
```
**Esempi di messaggi:**
- `./git-push.sh "Aggiunto sistema crafting"`
- `./git-push.sh "Fix bug raccolta oggetti"`
- `./git-push.sh "Nuovi sprite crops e tools"`

---

## 💻 **COMPUTER 2: Continuare il Lavoro**

### 1. **PRIMA VOLTA** (Solo se non hai mai clonato)
```bash
cd /path/dove/vuoi/il/progetto
git clone https://github.com/Amplaye/SeasonVale.git
cd SeasonVale
chmod +x git-push.sh git-pull.sh git-status.sh
```

### 2. **OGNI VOLTA CHE RIPRENDI** ⬇️
```bash
cd SeasonVale  
./git-pull.sh
```
**IMPORTANTE:** Fai SEMPRE questo prima di aprire GameMaker!

### 3. **LAVORA E SALVA** ⬆️
```bash
./git-push.sh "Le tue modifiche"
```

---

# 🆘 **GESTIONE CONFLITTI**

## ⚠️ **Quando Appare un Conflitto**
Se `git-pull.sh` dice che ci sono conflitti:

### 1. **Vedi Cosa è in Conflitto**
```bash
git status
```

### 2. **Risolvi Manualmente**
- Apri i file in conflitto con un editor di testo
- Cerca le righe con `<<<<<<<`, `=======`, `>>>>>>>`
- Scegli quale versione tenere
- Rimuovi i marcatori di conflitto

### 3. **Completa la Risoluzione**
```bash
git add .
git commit -m "Risolti conflitti"
./git-push.sh "Conflitti risolti"
```

---

# 📊 **COMANDI UTILI**

## 🔍 **Controllo Stato**
```bash
./git-status.sh          # Vedi stato completo del progetto
git log --oneline -10     # Vedi ultimi 10 commit
git diff                  # Vedi modifiche non salvate
```

## 🔧 **Operazioni Avanzate**
```bash
git stash                 # Metti da parte modifiche temporaneamente
git stash pop            # Recupera modifiche messe da parte
git reset --hard HEAD    # ATTENZIONE: Cancella tutte le modifiche locali
```

---

# ⚡ **AUTOMAZIONE COMPLETA**

## 🚀 **Script Creati per Te**

### `./git-pull.sh`
- Scarica modifiche da GitHub
- Controlla conflitti automaticamente
- Mostra messaggi di errore chiari

### `./git-push.sh "messaggio"`
- Aggiunge tutti i file modificati
- Crea commit con il tuo messaggio
- Carica tutto su GitHub
- Conferma successo/errore

### `./git-status.sh`
- Mostra stato completo del progetto
- Lista modifiche pending
- Mostra ultimi commit

---

# 🎯 **ROUTINE CONSIGLIATA**

## 📅 **Ogni Giorno**
1. **INIZIO**: `./git-pull.sh`
2. **LAVORO**: Sviluppa in GameMaker
3. **TEST**: Prova il gioco
4. **FINE**: `./git-push.sh "Cosa hai fatto oggi"`

## 🔄 **Cambio Computer**
1. Sul Computer A: `./git-push.sh "Work in progress"`
2. Sul Computer B: `./git-pull.sh`
3. Continua il lavoro
4. Sul Computer B: `./git-push.sh "Completato XYZ"`

---

# 📞 **IN CASO DI PROBLEMI**

## ❌ **Errori Comuni**

### "Repository ahead/behind"
```bash
./git-pull.sh    # Prima scarica
./git-push.sh    # Poi carica
```

### "Working directory not clean"
```bash
git add .
git commit -m "WIP - work in progress"
./git-pull.sh
```

### "Permission denied"
```bash
chmod +x git-*.sh
```

---

## 🛡️ **BACKUP AUTOMATICO**
Ogni commit è un backup automatico su GitHub. Anche se un computer si rompe, hai sempre tutto salvato online!

**Repository GitHub**: https://github.com/Amplaye/SeasonVale

---

*Ultimo aggiornamento: Configurazione iniziale Git completata ✅*