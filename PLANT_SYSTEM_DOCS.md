# 🌱 Plant System Documentation

## Overview
Il Plant System è un sistema centralizzato per gestire tutte le piante nel gioco. Sostituisce la logica individuale di ogni pianta con un sistema modulare e scalabile.

## Componenti Principali

### 1. **scr_plant_system.gml**
File centrale che contiene:
- Configurazioni di tutte le piante
- Funzioni per inizializzazione, crescita e harvest
- Sistema di gestione universale

### 2. **scr_seed_system.gml** 
Gestisce la mappatura semi -> piante:
- Mappa sprites dei semi ai tipi di piante
- Funzioni per validazione e piantatura
- Sistema di conversione semi/piante

### 3. **obj_universal_plant**
Oggetto pianta universale che sostituisce tutti gli oggetti pianta specifici:
- Usa le configurazioni da scr_plant_system
- Gestione automatica di crescita e harvest
- Sistema di rendering universale

### 4. **obj_plant_dev_tool**
Tool di sviluppo per testare e debuggare:
- Creazione piante di test
- Controllo crescita e harvest
- Gestione semi nella toolbar

## Aggiungere Nuove Piante

### Step 1: Aggiungi Configurazione
In `scr_plant_system.gml`, aggiungi la configurazione nella funzione `get_plant_configs()`:

```gml
"nuovo_tipo": {
    sprite: spr_nuova_pianta,
    max_growth_stage: 3,
    days_to_grow: 4,
    harvest_amount: 2,
    harvest_item: spr_nuovo_item,
    harvest_cooldown_frames: 60,
    reset_stage_after_harvest: 1, // -1 = distruggi, >=0 = reset a stage
    depth: 3,
    can_regrow: true,
    description: "Descrizione pianta"
}
```

### Step 2: Aggiungi Mappatura Seme
In `scr_seed_system.gml`, aggiungi la mappatura nella funzione `get_seed_to_plant_mapping()`:

```gml
spr_nuovo_seme: "nuovo_tipo"
```

### Step 3: Sprite Requirements
- **spr_nuova_pianta**: Sprite con frame multipli per gli stadi di crescita
- **spr_nuovo_seme**: Sprite del seme per la toolbar
- **spr_nuovo_item**: Sprite dell'item raccolto

### Step 4: Testing
Usa il Plant Dev Tool:
1. Premi `P` per attivare dev mode
2. Premi `S` per aggiungere semi alla toolbar
3. Premi `C` per creare piante di test
4. Premi `G` per forzare crescita

## Configurazioni Pianta

| Parametro | Descrizione |
|-----------|-------------|
| `sprite` | Sprite della pianta (con frame multipli) |
| `max_growth_stage` | Numero massimo di stadi (0-based) |
| `days_to_grow` | Giorni necessari per crescita completa |
| `harvest_amount` | Quantità raccolta per harvest |
| `harvest_item` | Sprite dell'item raccolto |
| `harvest_cooldown_frames` | Frames di cooldown dopo harvest |
| `reset_stage_after_harvest` | Stage dopo harvest (-1 = distruggi) |
| `depth` | Depth di rendering |
| `can_regrow` | Se può essere raccolta più volte |
| `description` | Descrizione testuale |

## Funzioni Principali

### Plant System
- `get_plant_config(plant_type)` - Ottieni configurazione pianta
- `init_plant(plant_type, instance_id)` - Inizializza pianta
- `advance_plant_growth(instance_id)` - Avanza crescita
- `harvest_plant_universal(instance_id)` - Raccogli pianta

### Seed System  
- `get_plant_type_from_seed(seed_sprite)` - Tipo pianta da sprite seme
- `is_valid_seed(seed_sprite)` - Controlla se seme è valido
- `plant_seed_at_position(seed_sprite, x, y)` - Pianta seme

### Toolbar Seeds
- `add_all_seeds_to_toolbar()` - Aggiungi tutti i semi
- `add_seed_to_toolbar(plant_type, quantity)` - Aggiungi seme specifico
- `remove_all_seeds_from_toolbar()` - Rimuovi tutti i semi

## Plant Dev Tool Commands

| Comando | Azione |
|---------|---------|
| `P` | Toggle plant dev mode |
| `I` | Show/hide plant info overlay |
| `C` | Create test plants |
| `G` | Grow all plants +1 stage |
| `H` | Harvest all ready plants |
| `R` | Remove all plants |
| `D` | Debug print all plant configs |
| `S` | Add all seeds to toolbar |
| `X` | Remove all seeds from toolbar |

## Compatibilità
Il sistema mantiene compatibilità con le vecchie piante durante la transizione:
- `obj_tomato_plant` continua a funzionare
- Il time manager aggiorna entrambi i sistemi
- Migrazione graduale possibile

## Performance
Il sistema è ottimizzato per performance:
- Configurazioni caricate una sola volta
- Logica condivisa tra tutte le piante
- Nessuna duplicazione di codice
- Sistema di caching per configurazioni

## Esempio Completo: Aggiungere Patate

1. **Configurazione in scr_plant_system.gml:**
```gml
"potato": {
    sprite: spr_potato_plant,
    max_growth_stage: 2,
    days_to_grow: 3,
    harvest_amount: 4,
    harvest_item: spr_potato,
    harvest_cooldown_frames: 45,
    reset_stage_after_harvest: -1,
    depth: 3,
    can_regrow: false,
    description: "Patate nutrienti"
}
```

2. **Mappatura in scr_seed_system.gml:**
```gml
spr_potato: "potato"
```

3. **Test:**
- Aggiungi `{type: "potato", x: 400, y: 200}` in `test_plants` del dev tool
- Usa comandi dev tool per testare

Fatto! La patata è ora disponibile nel sistema.