if (visible) {
    // Controlla se obj_mark_stats è attivo per decidere quale sprite usare
    var menu_sprite = sprite_index; // Default: menu_basic
    
    if (instance_exists(obj_mark_stats)) {
        with (obj_mark_stats) {
            if (is_active) {
                menu_sprite = menu_stats; // Usa sprite di obj_main_menu_stats
            }
        }
    }
    
    // Disegna il menu con lo sprite appropriato
    draw_sprite_ext(menu_sprite, 0, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}