if (visible) {
    // Nascondi il cursore di Windows e usa solo lo sprite personalizzato
    window_set_cursor(cr_none);
    cursor_sprite = pointer;
    
    // Controlla se obj_mark_stats è attivo per decidere quale sprite usare
    var menu_sprite = sprite_index; // Default: menu_basic
    
    if (instance_exists(obj_mark_stats)) {
        with (obj_mark_stats) {
            if (is_active) {
                menu_sprite = menu_stats; // Usa sprite di obj_main_menu_stats
            }
        }
    }
    
    // Calcola la posizione centrata rispetto alla view corrente
    var cam = view_camera[0];
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);
    
    var center_x = view_x + view_w / 2;
    var center_y = view_y + view_h / 2;
    
    // Disegna il menu centrato nella view
    draw_sprite_ext(menu_sprite, 0, center_x, center_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}