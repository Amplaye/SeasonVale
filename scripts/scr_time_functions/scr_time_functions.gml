// ===================================================================
// ⏰ FUNZIONI GLOBALI PER IL SISTEMA TEMPO
// ===================================================================

function advance_day() {
    var time_manager = instance_find(obj_time_manager, 0);
    if (!instance_exists(time_manager)) return;

    global.game_day++;
    global.game_hour = time_manager.min_hour;  // Reset alle 6:00 AM
    global.game_minute = 0;

    // Notifica crescita piante - anche quelle caricate da save
    with (obj_universal_plant) {
        // Temporaneamente disabilita il flag per permettere crescita
        var was_loaded = is_loaded_from_save;
        is_loaded_from_save = false;
        advance_plant_growth(id);
        is_loaded_from_save = was_loaded;  // Ripristina flag
    }

    // Mantieni compatibilità con vecchie piante durante transizione
    with (obj_tomato_plant) {
        // Temporaneamente disabilita il flag per permettere crescita
        var was_loaded = is_loaded_from_save;
        is_loaded_from_save = false;
        advance_growth();
        is_loaded_from_save = was_loaded;  // Ripristina flag
    }

    with (time_manager) {
        update_time_overlay();
    }
}

function advance_hour() {
    var time_manager = instance_find(obj_time_manager, 0);
    if (!instance_exists(time_manager)) return;

    global.game_hour++;

    // Se supera l'ora massima, avanza al giorno successivo
    if (global.game_hour > time_manager.max_hour) {
        advance_day();
    } else {
        with (time_manager) {
            update_time_overlay();
        }
    }
}