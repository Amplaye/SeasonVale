// ===================================================================
// 🌱 UNIVERSAL PLANT - OGGETTO PIANTA UNIVERSALE
// ===================================================================
// Sostituisce tutte le piante individuali (obj_tomato_plant, ecc.)
// Usa il sistema centralizzato scr_plant_system per la configurazione

// Variabili che verranno impostate da init_plant()
plant_type = "";
growth_stage = 0;
max_growth_stage = 0;
days_to_grow = 0;
planted_day = 0;

can_harvest = false;
harvest_cooldown = 0;
harvest_amount = 0;
harvest_item = noone;
harvest_cooldown_frames = 0;
reset_stage_after_harvest = 0;
can_regrow = true;

// NOTA: Questo oggetto viene inizializzato chiamando init_plant(plant_type, id)
// dal tilled_soil quando viene piantato un seme

// Depth rimosso - sarà impostato direttamente nell'editor

// show_debug_message("🌱 Universal plant created (awaiting initialization)");