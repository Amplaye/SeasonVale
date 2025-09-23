# 🖥️ Sistema Display Multi-Piattaforma SeasonVale

Il sistema display di SeasonVale è stato completamente riprogettato per offrire la migliore qualità grafica su tutte le piattaforme supportate, con rilevamento automatico e ottimizzazione intelligente.

## 🔧 Caratteristiche Principali

### Rilevamento Automatico Piattaforma
- **Windows**: Ottimizzazione per desktop e gaming
- **macOS**: Supporto nativo per display Retina (High DPI)
- **Linux**: Configurazione bilanciata per varie distribuzioni
- **Steam Deck**: Profilo ottimizzato per handheld gaming

### Scaling Intelligente
- Rilevamento automatico DPI display
- Calcolo ottimale della qualità in base alle dimensioni dello schermo
- Adattamento dinamico ai cambiamenti di display
- Supporto per display multipli

## ⚙️ Profili Qualità per Piattaforma

### Windows
- **Qualità Default**: 3x (1440x810)
- **Qualità Massima**: 5x (2400x1350)
- **Texture Filtering**: Disabilitato (pixel perfect)
- **VSync**: Disabilitato (migliore performance gaming)

### macOS
- **Qualità Default**: 4x su Retina, 3x su display standard
- **Qualità Massima**: 5x
- **Texture Filtering**: Disabilitato (pixel perfect)
- **VSync**: Abilitato (migliore fluidità su Mac)
- **Supporto Retina**: Abilitato automaticamente

### Linux
- **Qualità Default**: 3x
- **Qualità Massima**: 4x
- **Texture Filtering**: Disabilitato
- **VSync**: Disabilitato

### Steam Deck
- **Qualità Default**: 2x (960x540)
- **Qualità Massima**: 3x (1440x810)
- **Ottimizzazioni**: Scaling limitato per performance
- **VSync**: Abilitato per fluidità

## 🎮 Controlli in-Game

Durante il gioco, puoi utilizzare questi controlli:

- **F11**: Toggle fullscreen/windowed
- **1-5**: Imposta qualità specifica (1=minima, 5=massima)
- **A**: Auto-ottimizzazione automatica per il display corrente
- **R**: Reset pixel perfect (risolve problemi grafici)
- **+/-**: Aumenta/diminuisci scala font
- **=/‒**: Alternative per scala font

## 📐 Specifiche Tecniche

### Risoluzione Base
- **Camera Size**: 480x270 pixel
- **Scaling**: Da 1x a 5x basato sulla piattaforma
- **Formato**: 16:9 ottimizzato per pixel art

### Rilevamento Retina (macOS)
- **Soglia DPI**: 144+ considerato Retina
- **Scaling Speciale**: 1.5x moltiplicatore per display ad alta densità
- **Auto-ottimizzazione**: Qualità 4x default su Retina

### Ottimizzazioni Steam Deck
- **Risoluzione Display**: 1280x800
- **Scaling Limitato**: Massimo 3x per mantenere 60fps
- **Margine Performance**: 20% dello schermo libero per UI sistema

## 🐛 Troubleshooting

### Display Sfocato
- Premi **R** per reset pixel perfect
- Verifica che texture filtering sia disabilitato
- Su Mac, verifica che Retina sia abilitato nelle opzioni

### Performance Basse
- Premi **A** per auto-ottimizzazione
- Abbassa manualmente con tasti **1-3**
- Su Steam Deck, usa massimo qualità **2**

### Finestra Troppo Grande/Piccola
- Premi **A** per calcolo automatico dimensioni ottimali
- Usa **F11** per fullscreen se la finestra non entra
- Cambia manualmente qualità con tasti numerici

## 📊 Monitoraggio

Il sistema registra automaticamente:
- Piattaforma rilevata
- DPI display corrente
- Stato Retina (solo Mac)
- Qualità ottimale calcolata vs applicata
- Cambiamenti display (ogni 3 secondi)

Tutti i messaggi sono visibili nel debug output di GameMaker.

## 🔮 Funzionalità Future

- Salvataggio preferenze qualità per dispositivo
- Profili personalizzati utente
- Supporto per display ultra-wide
- HDR su piattaforme supportate