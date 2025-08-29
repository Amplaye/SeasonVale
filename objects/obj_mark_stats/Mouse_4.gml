// Click sinistro del mouse
if (visible && instance_exists(obj_main_menu) && obj_main_menu.visible) {
    // Disattiva tutti gli altri mark e nascondi player preview
    with (obj_main_menu) {
        for (var i = 0; i < array_length(mark_objects); i++) {
            if (instance_exists(mark_objects[i])) {
                with (mark_objects[i]) {
                    is_active = false;
                    image_index = 0; // Frame 0 = chiuso
                }
            }
        }
        
        // Nascondi player preview prima di attivare stats
        if (instance_exists(player_preview_object)) {
            with (player_preview_object) {
                visible = false;
            }
        }
    }
    
    // Attiva questo mark
    is_active = true;
    image_index = 1; // Frame 1 = aperto
    
    // Mostra player preview solo per Stats
    if (instance_exists(obj_main_menu)) {
        with (obj_main_menu) {
            if (instance_exists(player_preview_object)) {
                with (player_preview_object) {
                    visible = true;
                }
            }
        }
    }
    
    show_debug_message("Stats page clicked and activated! Player preview shown!");
}