if (keyboard_check_pressed(vk_escape)) {
    visible = !visible;
    show_debug_message("ESC pressed! Main Menu visible: " + string(visible));
    
    if (visible) {
        
        // Blocca il movimento del player
        if (instance_exists(obj_player)) {
            obj_player.can_move = false;
        }
        
        // Mostra tutti i mark come inattivi
        for (var i = 0; i < array_length(mark_objects); i++) {
            if (instance_exists(mark_objects[i])) {
                show_debug_message("Found mark object: " + object_get_name(mark_objects[i]));
                with (mark_objects[i]) {
                    visible = true;
                    is_active = false;
                    image_index = 0; // Tutti inattivi all'apertura
                }
            } else {
                show_debug_message("Mark object NOT found: " + object_get_name(mark_objects[i]));
            }
        }
        
        // Attiva obj_mark_stats come pagina iniziale
        if (instance_exists(obj_mark_stats)) {
            with (obj_mark_stats) {
                is_active = true;
                image_index = 1; // Frame aperto
            }
        }
        
        // Mostra player preview per stats (pagina iniziale)
        if (instance_exists(player_preview_object)) {
            with (player_preview_object) {
                visible = true;
            }
        }
    } else {
        
        // Riabilita il movimento del player
        if (instance_exists(obj_player)) {
            obj_player.can_move = true;
        }
        
        // Nascondi tutti i mark
        for (var i = 0; i < array_length(mark_objects); i++) {
            if (instance_exists(mark_objects[i])) {
                with (mark_objects[i]) {
                    visible = false;
                    is_active = false;
                    image_index = 0;
                }
            }
        }
        
        // Nascondi player preview quando si chiude il menu
        if (instance_exists(player_preview_object)) {
            with (player_preview_object) {
                visible = false;
            }
        }
    }
}