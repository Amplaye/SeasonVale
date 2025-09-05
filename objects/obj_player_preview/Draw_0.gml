if (visible && instance_exists(obj_main_menu) && obj_main_menu.visible) {
    
    current_frame += frame_speed / game_get_speed(gamespeed_fps);
    if (current_frame >= sprite_get_number(base_sprite)) {
        current_frame = 0;
    }
    
    // Calcola il centro dinamico del menu
    var cam = view_camera[0];
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);
    
    var menu_center_x = view_x + view_w / 2;
    var menu_center_y = view_y + view_h / 2;
    
    // Applica l'offset memorizzato dall'editor
    var player_x = menu_center_x + offset_from_menu_x;
    var player_y = menu_center_y + offset_from_menu_y;
    
    // Scala fissa a 1.5 per il player preview
    var preview_scale = 1.5;
    
    // Disegna il player nella posizione calcolata
    draw_sprite_ext(base_sprite, current_frame, player_x, player_y, preview_scale, preview_scale, 0, c_white, 1);
    
}