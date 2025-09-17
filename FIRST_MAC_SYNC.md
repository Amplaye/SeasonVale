# 🍎 PRIMA SINCRONIZZAZIONE SU MAC

## ⚠️ **IMPORTANTE: LEGGI PRIMA DI INIZIARE**

Questa guida è per la **prima volta** che apri il progetto su Mac dopo gli aggiornamenti Windows.

---

## 🚀 **PROCEDURA SINCRONIZZAZIONE COMPLETA**

### **1. Apri Terminal su Mac**
```bash
cd /path/to/SeasonVale
```

### **2. BACKUP delle modifiche locali (se ci sono)**
```bash
# Solo se hai modifiche locali che vuoi salvare
git add -A
git commit -m "Backup modifiche locali Mac prima sync"
```

### **3. SYNC FORZATO (sovrascrive tutto)**
```bash
# Scarica TUTTO dal repository Windows
git fetch --all
git reset --hard origin/main

# Rendi eseguibili gli script
chmod +x sync_mac.sh
chmod +x sync_windows.bat
```

### **4. Verifica sincronizzazione**
```bash
# Questo script ora verifica che tutto sia sincronizzato
./sync_mac.sh
```

**Dovresti vedere:**
```
✅ Sistema performance trovato
✅ FPS Counter trovato
✅ SINCRONIZZAZIONE COMPLETATA!
```

---

## 📁 **NUOVI FILE CHE RICEVERAI:**

```
📂 objects/
  └── obj_fps_counter/          # FPS counter real-time
      ├── obj_fps_counter.yy
      ├── Create_0.gml
      └── Draw_64.gml

📂 scripts/
  ├── scr_performance_optimizer/ # Ottimizzazioni Mac M2
  │   ├── scr_performance_optimizer.gml
  │   └── scr_performance_optimizer.yy
  └── scr_profiler/             # Sistema monitoring
      ├── scr_profiler.gml
      └── scr_profiler.yy

📂 objects/obj_main_menu/
  └── Alarm_0.gml               # Frame counter

📂 root/
  ├── MAC_M2_PERFORMANCE_GUIDE.md
  ├── FIRST_MAC_SYNC.md
  └── sync_mac.sh (aggiornato)
```

---

## 🧪 **DOPO LA SINCRONIZZAZIONE:**

### **1. Apri GameMaker Studio**
- Apri il progetto `SeasonVale.yyp`
- Seleziona target: **macOS**

### **2. Aggiungi eventi mancanti (se necessario):**

**obj_fps_counter:**
- Se manca **Alarm 0**: Aggiungi e incolla:
```gml
// Update FPS ogni 10 frame
update_timer++;
if (update_timer >= 10) {
    fps_current = fps_real;
    array_push(fps_history, fps_current);
    if (array_length(fps_history) > 5) {
        array_delete(fps_history, 0, 1);
    }
    var total = 0;
    for (var i = 0; i < array_length(fps_history); i++) {
        total += fps_history[i];
    }
    fps_smooth = total / array_length(fps_history);
    update_timer = 0;
}
alarm[0] = 10;
```

### **3. Build e Test**
- Build per macOS
- Verifica FPS counter in alto a sinistra
- Dovrebbe mostrare: `FPS: XX MAC`

---

## 🔄 **SINCRONIZZAZIONI FUTURE**

Dopo questa prima volta, usa sempre:
```bash
./sync_mac.sh
```

Non serve più `git reset --hard` perché il sistema sarà già sincronizzato.

---

## 🐛 **TROUBLESHOOTING**

### **Problema: File mancanti dopo sync**
```bash
# Forza re-download completo
rm -rf .git/index
git reset --hard origin/main
./sync_mac.sh
```

### **Problema: Permission denied**
```bash
chmod +x sync_mac.sh
chmod 644 objects/**/*.gml
chmod 644 scripts/**/*.gml
```

### **Problema: GameMaker non trova oggetti**
1. Chiudi GameMaker
2. Riapri il progetto
3. Refresh Asset Browser (F5)

---

## ✅ **CONFERMA SINCRONIZZAZIONE RIUSCITA**

Dovresti vedere nel gioco:
- 📊 **FPS Counter** in alto a sinistra
- 🏠 **obj_house** al depth corretto
- 🎮 **Performance migliorate** su Mac M2
- 🖥️ **"MAC" nella label** del FPS counter