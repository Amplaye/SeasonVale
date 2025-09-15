// Se caricata da save, NON fare mai controlli automatici di crescita
if (is_loaded_from_save) {
    // Le piante caricate mantengono il loro stato esatto
    if (harvest_cooldown > 0) harvest_cooldown--;

    // Controlli harvest ma NO crescita automatica
    if (can_harvest && harvest_cooldown <= 0) {
        var player = instance_find(obj_player, 0);
        if (instance_exists(player) && distance_to_object(player) < 32) {
            if (mouse_check_button_pressed(mb_left)) {
                if (harvest_tomato()) {
                    harvest_cooldown = 180;  // 3 secondi a 60 FPS
                }
            }
        }
    }
    exit;  // Salta tutta la logica di crescita automatica
}

// Riduci cooldown harvest
if (harvest_cooldown > 0) {
    harvest_cooldown--;
}

// Controlla crescita giornaliera SOLO se il giorno è cambiato
if (global.game_day > last_growth_check_day) {
    var days_passed = global.game_day - planted_day;
    var expected_stage = min(floor(days_passed), max_growth_stage);

    if (expected_stage > growth_stage) {
        advance_growth();
    }

    last_growth_check_day = global.game_day;  // Aggiorna ultimo check
}

// Controlla se il player vuole raccogliere
if (can_harvest && harvest_cooldown <= 0) {
    var player = instance_find(obj_player, 0);
    if (player != noone) {
        var dist_to_player = point_distance(x, y, player.x, player.y);
        
        // Se il player è vicino e clicca con tasto destro E non è già stato fatto harvest questo frame
        if (dist_to_player < 32 && mouse_check_button_pressed(mb_right) && !global.harvest_this_frame) {
            // Imposta flag per impedire altri harvest questo frame
            global.harvest_this_frame = true;
            harvest_plant();
        }
    }
}