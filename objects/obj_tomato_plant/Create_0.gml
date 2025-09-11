// Sistema di crescita della pianta di pomodoro
growth_stage = 0;           // Stadio attuale (0-4)
max_growth_stage = 4;       // 5 stadi totali (0-4)
days_to_grow = 5;           // 5 giorni per crescita completa
planted_day = global.game_day;  // Giorno in cui è stata piantata

// Variabili per harvest
can_harvest = false;        // Se può essere raccolta
harvest_cooldown = 0;       // Cooldown dopo harvest
harvest_amount = 3;         // Quantità di pomodori per harvest

// Posizione fissa (già centrata dal tilled_soil)
// Non serve riallineare, eredita la posizione corretta
depth = 3;                  // Sopra il terreno ma sotto il player

// Imposta sprite e frame iniziale
sprite_index = spr_tomatoes;    // Sprite con 5 frame
image_index = growth_stage;
image_speed = 0;            // Niente animazione automatica

show_debug_message("🌱 Tomato plant created - Stage: " + string(growth_stage) + " Day: " + string(planted_day));

// Funzione per far crescere la pianta
function advance_growth() {
    var days_passed = global.game_day - planted_day;
    var expected_stage = min(floor(days_passed), max_growth_stage);
    
    if (expected_stage > growth_stage) {
        growth_stage = expected_stage;
        image_index = growth_stage;
        
        // Se raggiunge l'ultimo stadio, può essere raccolta
        if (growth_stage >= max_growth_stage) {
            can_harvest = true;
        }
    }
}

// Funzione per raccogliere
function harvest_plant() {
    if (!can_harvest || harvest_cooldown > 0) return false;
    
    // Raccogli pomodori (silenzioso)
    // Qui aggiungeresti i pomodori all'inventario
    // global.inventory_add("tomato", harvest_amount);
    
    // Reset alla stage 2 (continua a produrre)
    growth_stage = 2;
    image_index = growth_stage;
    can_harvest = false;
    harvest_cooldown = 30;  // 30 frame di cooldown
    
    // Harvest completato (niente popup, oggetto non esiste)
    
    return true;
}