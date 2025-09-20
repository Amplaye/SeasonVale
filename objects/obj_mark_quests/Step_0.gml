// Logica specifica per la pagina Quests
if (is_active && visible) {
    // Controlli per gestire le quest

    // Q = Avvia "First Harvest"
    if (keyboard_check_pressed(ord("Q"))) {
        if (quest_is_available("first_harvest")) {
            quest_start("first_harvest");
            show_debug_message("Quest 'First Harvest' started!");
        } else {
            show_debug_message("Quest 'First Harvest' not available");
        }
    }

    // W = Avvia "Welcome to the Valley"
    if (keyboard_check_pressed(ord("W"))) {
        if (quest_is_available("meet_villagers")) {
            quest_start("meet_villagers");
            show_debug_message("Quest 'Welcome to the Valley' started!");
        } else {
            show_debug_message("Quest 'Welcome to the Valley' not available");
        }
    }

    // E = Avvia "Resource Gathering"
    if (keyboard_check_pressed(ord("E"))) {
        if (quest_is_available("gather_resources")) {
            quest_start("gather_resources");
            show_debug_message("Quest 'Resource Gathering' started!");
        } else {
            show_debug_message("Quest 'Resource Gathering' not available");
        }
    }
}