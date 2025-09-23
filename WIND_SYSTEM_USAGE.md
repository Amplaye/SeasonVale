# 🌬️ WIND SYSTEM - Guida Utilizzo

## Panoramica
Sistema di vento persistente e naturale per SeasonVale che gestisce movimento realistico di erba, alberi, fiori e altri elementi naturali.

## Componenti Creati

### 1. **obj_wind_manager** - Manager Centrale
- **File**: `objects/obj_wind_manager/`
- **Funzione**: Controlla parametri globali, direzione, intensità del vento
- **Proprietà**: Persistent=true, Depth=-15000
- **Auto-Spawning**: Il sistema crea automaticamente il manager se necessario

### 2. **scr_wind_system** - Funzioni Helper
- **File**: `scripts/scr_wind_system/scr_wind_system.gml`
- **Funzioni principali**:
  - `get_wind_offset_x(profile, offset)` - Movimento orizzontale
  - `get_wind_offset_y(profile, offset)` - Movimento verticale
  - `get_wind_rotation(profile, offset)` - Rotazione
  - `apply_wind_to_sprite(sprite, x, y, profile, offset)` - Rendering automatico

### 3. **Profili Vento Predefiniti**
- **grass**: Movimento delicato e frequente
- **tree**: Movimento lento e ampio
- **flower**: Movimento molto delicato
- **leaves**: Movimento rapido e leggero
- **bush**: Movimento medio

### 4. **obj_grass_wind_example** - Esempio d'Uso
- **File**: `objects/obj_grass_wind_example/`
- **Scopo**: Dimostra implementazione pratica

## Come Utilizzare

### Metodo Semplice (Raccomandato)
```gml
// Nel Draw event del tuo oggetto
apply_wind_to_sprite(spr_my_grass, x, y, "grass", id);
```

### Metodo Avanzato (Controllo Manuale)
```gml
// Nel Draw event
var wind_x = get_wind_offset_x("grass", id);
var wind_y = get_wind_offset_y("grass", id);
var wind_rot = get_wind_rotation("grass", id);

draw_sprite_ext(spr_my_grass, 0, x + wind_x, y + wind_y,
               1, 1, wind_rot, c_white, 1.0);
```

### Per Oggetti Esistenti
Per aggiungere vento a oggetti già esistenti:

1. Nel **Draw event**, sostituisci:
   ```gml
   draw_sprite(sprite_index, 0, x, y);
   ```
   Con:
   ```gml
   apply_wind_to_sprite(sprite_index, x, y, "grass", id);
   ```

2. Scegli il profilo appropriato:
   - Erba/piante piccole: `"grass"`
   - Alberi: `"tree"`
   - Fiori: `"flower"`
   - Arbusti: `"bush"`
   - Foglie: `"leaves"`

## Controlli Runtime

### Funzioni di Controllo
```gml
set_wind_intensity(1.5);    // Aumenta intensità del vento
set_wind_speed(0.5);        // Rallenta velocità vento
toggle_wind();              // Abilita/disabilita vento
```

### Variabili Globali
- `global.wind_enabled` - Enable/disable
- `global.wind_global_intensity` - Intensità globale
- `global.wind_global_speed` - Velocità globale
- `global.wind_time` - Timer principale

## Personalizzazione Profili

Per creare profili personalizzati:
```gml
// Nel Create event di obj_wind_manager
global.wind_profiles[$ "my_custom"] = {
    amplitude: 3.0,          // Ampiezza movimento
    frequency: 0.8,          // Frequenza oscillazione
    offset_variation: 10.0,  // Variazione anti-sincronizzazione
    damping: 0.9,           // Smorzamento
    direction_influence: 0.4 // Influenza direzione vento
};
```

## Performance
- ✅ **Ottimizzato**: Calcoli matematici leggeri
- ✅ **Scalabile**: Gestisce centinaia di oggetti
- ✅ **Persistente**: Funziona tra room changes
- ✅ **Auto-gestito**: Crea manager automaticamente se necessario

## Note Implementazione
- Ogni oggetto deve usare un `unique_offset` diverso (solitamente `id`)
- Il sistema è automaticamente persistente tra le room
- Non richiede setup manuale - funziona immediatamente
- Compatibile con oggetti esistenti - basta cambiare il Draw event