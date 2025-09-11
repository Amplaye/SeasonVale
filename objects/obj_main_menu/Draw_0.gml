if (visible) {
    // Nascondi il cursore di Windows e usa solo lo sprite personalizzato
    window_set_cursor(cr_none);
    cursor_sprite = spr_pointer;
    
    // Determina quale sprite usare
    var menu_sprite = spr_menu_basic;
    
    // Se Stats è attiva, usa menu_stats
    if (instance_exists(obj_mark_stats)) {
        with (obj_mark_stats) {
            if (is_active) {
                menu_sprite = spr_menu_stats;
            }
        }
    }
    
    // Calcola posizione centrata
    var cam = view_camera[0];
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);
    
    var center_x = view_x + view_w / 2;
    var center_y = view_y + view_h / 2;
    
    // Disegna il menu con parametri completamente fissi
    draw_sprite_ext(menu_sprite, 0, center_x, center_y, 1, 1, 0, c_white, 1);
}