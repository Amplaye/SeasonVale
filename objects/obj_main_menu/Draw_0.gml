if (visible) {
    // Gestione cursore personalizzato - ottimizzata per evitare chiamate ripetute
    if (!variable_instance_exists(id, "cursor_already_set") || !cursor_already_set) {
        window_set_cursor(cr_none);
        cursor_sprite = spr_pointer;
        cursor_already_set = true;
    }

    // Ottimizzazione: controlla sprite solo ogni 3 frame
    if (sprite_check_counter == 0) {
        cached_menu_sprite = spr_menu_basic;

        // Se Stats è attiva, usa menu_stats
        if (instance_exists(obj_mark_stats)) {
            with (obj_mark_stats) {
                if (is_active) {
                    other.cached_menu_sprite = spr_menu_stats;
                }
            }
        }
    }
    sprite_check_counter = (sprite_check_counter + 1) % 3;

    // Calcola posizione centrata
    var cam = view_camera[0];
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);

    var center_x = view_x + view_w / 2;
    var center_y = view_y + view_h / 2;

    // Disegna il menu usando sprite cached
    draw_sprite_ext(cached_menu_sprite, 0, center_x, center_y, 1, 1, 0, c_white, 1);
} else {
    // Reset flag quando il menu non è visibile
    if (variable_instance_exists(id, "cursor_already_set")) {
        cursor_already_set = false;
    }
}