// ===================================================================
// 🌱 UNIVERSAL PLANT - STEP EVENT
// ===================================================================

// Esci se non inizializzato
if (plant_type == "") exit;


// Se caricata da save, NON fare mai controlli automatici di crescita
if (is_loaded_from_save) {
    // Le piante caricate mantengono il loro stato esatto
    // La crescita avverrà solo con advance_day() espliciti
    if (harvest_cooldown > 0) harvest_cooldown--;

    // Controlli harvest ma NO crescita automatica
    if (can_harvest && harvest_cooldown <= 0) {
        var player = instance_find(obj_player, 0);
        if (instance_exists(player) && distance_to_object(player) < 32) {
            if (mouse_check_button_pressed(mb_right)) {
                if (harvest_plant_universal(id)) {
                    harvest_cooldown = harvest_cooldown_frames;
                }
            }
        }
    }
    exit;  // Salta advance_plant_growth
}

// Riduci cooldown harvest
if (harvest_cooldown > 0) {
    harvest_cooldown--;
}

// Controlla crescita giornaliera usando il sistema centralizzato
advance_plant_growth(id);

