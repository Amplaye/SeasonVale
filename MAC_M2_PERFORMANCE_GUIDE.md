# 🍎 MAC M2 PERFORMANCE OPTIMIZATION GUIDE

## 🚀 OTTIMIZZAZIONI IMPLEMENTATE

### **Sistema di Performance Automatico**
- ✅ **Depth sorting ottimizzato**: aggiorna ogni 3 frame invece di ogni frame su Mac
- ✅ **Cache delle istanze**: riduce `instance_find()` operations su Mac
- ✅ **Debug messages smart**: disabilitati automaticamente su Mac per performance
- ✅ **Profiler automatico**: si attiva se FPS < 30 su Mac

### **Script Aggiunti**
1. `scr_performance_optimizer.gml` - Ottimizzazioni specifiche per piattaforma
2. `scr_profiler.gml` - Sistema di monitoraggio performance

---

## 🧪 COME TESTARE SU MAC M2

### **1. Sincronizzazione Iniziale**
```bash
# Su Mac, esegui prima di tutto:
chmod +x sync_mac.sh
./sync_mac.sh

# Apri GameMaker Studio
# Seleziona target: macOS
# Build e Run
```

### **2. Test Performance Comparativi**

**PRIMA (senza ottimizzazioni):**
- Nota FPS in game
- Conta quanti oggetti riesci a mettere prima del lag
- Osserva fluidità movimenti

**DOPO (con ottimizzazioni):**
- Le ottimizzazioni si attivano automaticamente su Mac
- Dovresti vedere FPS più stabili
- Meno lag con molti oggetti

### **3. Monitoraggio Automatico**

Il sistema si auto-monitora:
- Se FPS < 30 → Profiler si attiva automaticamente
- Report performance ogni 3 secondi
- Ottimizzazioni specifiche Mac sempre attive

### **4. Debug Performance**

Per forzare il profiling:
```gml
// In qualsiasi oggetto, aggiungi nel Create:
profiler_enable();

// Per vedere report immediato:
profiler_report();
```

---

## 🔧 SETTINGSPER MAC M2

### **GameMaker Settings Consigliati:**
1. **Graphics → Rendering**: Metal (non OpenGL)
2. **Game Options → macOS**:
   - Enable Retina Display: OFF (per performance)
   - Use Synchronization: ON
3. **Texture Groups**: Compress tutte le texture

### **Se hai ancora problemi:**

1. **Controlla Activity Monitor** per uso CPU/GPU
2. **Thermal throttling**: Assicurati che Mac non sia troppo caldo
3. **Background apps**: Chiudi app non necessarie
4. **GameMaker IDE**: Usa versione native ARM64 se disponibile

---

## 📊 BENCHMARK TESTS

### **Test 1: Depth Sorting**
- Crea 50+ oggetti depth-sorted
- Windows: dovrebbe rimanere 60 FPS
- Mac (prima): probabilmente 30-40 FPS
- Mac (dopo): dovrebbe migliorare a 45-55 FPS

### **Test 2: Plant Operations**
- Pianta 20+ piante
- Fai crescere tutte insieme
- Windows: smooth
- Mac (prima): lag durante crescita
- Mac (dopo): crescita più fluida

### **Test 3: Menu Navigation**
- Naviga velocemente tra menu
- Windows: istantaneo
- Mac (prima): lag visibile
- Mac (dopo): molto più responsivo

---

## 🐛 TROUBLESHOOTING

### **Problema: FPS ancora bassi**
```bash
# Verifica se ottimizzazioni sono attive:
# Nel game, premi F12 per vedere console debug
# Dovresti vedere: "Platform detected: mac"
# E: "Mac optimizations applied"
```

### **Problema: Profiler non si attiva**
```gml
// Forza attivazione in obj_main_menu Create:
global.force_debug_mac = true;
profiler_enable();
```

### **Problema: Build fallisce su Mac**
1. Verifica che hai GameMaker per macOS installato
2. Controlla permessi file: `chmod 644 *.gml`
3. Usa sync_mac.sh prima di ogni build

---

## 🎯 RISULTATI ATTESI

**Performance Target su Mac M2:**
- FPS minimo: 45+ (vs 25-30 prima)
- Lag oggetti: Ridotto del 60%
- Menu navigation: Più fluida
- Memory usage: Ottimizzato

Se non raggiungi questi target, controlla che:
1. Tutte le ottimizzazioni siano attive
2. Non ci siano memory leak
3. GameMaker usi Metal renderer
4. Background apps siano chiuse