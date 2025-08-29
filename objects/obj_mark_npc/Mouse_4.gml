// Click sinistro del mouse
if (visible && instance_exists(obj_main_menu) && obj_main_menu.visible) {
    // Disattiva tutti gli altri mark
    with (obj_main_menu) {
        for (var i = 0; i < array_length(mark_objects); i++) {
            if (instance_exists(mark_objects[i])) {
                with (mark_objects[i]) {
                    is_active = false;
                    image_index = 0; // Frame 0 = chiuso
                }
            }
        }
        
        // Nascondi player preview per pagine non-Stats
        if (instance_exists(player_preview_object)) {
            with (player_preview_object) {
                visible = false;
            }
        }
    }
    
    // Attiva questo mark
    is_active = true;
    image_index = 1; // Frame 1 = aperto
    
    show_debug_message("NPC page clicked and activated!");
}