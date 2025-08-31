if (visible && instance_exists(obj_main_menu) && obj_main_menu.visible) {
    
    current_frame += frame_speed / game_get_speed(gamespeed_fps);
    if (current_frame >= sprite_get_number(base_sprite)) {
        current_frame = 0;
    }
    
    // Calcola posizione relativa al centro della view
    var cam = view_camera[0];
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);
    
    var center_x = view_x + view_w / 2;
    var center_y = view_y + view_h / 2;
    
    // Offset dal centro del menu (188-240, 100-137)
    var offset_x = -52;
    var offset_y = -37;
    
    // Aggiorna la posizione dell'oggetto
    x = center_x + offset_x;
    y = center_y + offset_y;
    
    // Calcola posizione centrata del player
    var player_center_x = x;
    var player_center_y = y;
    
    // Scala fissa a 1.5 per il player preview
    var preview_scale = 1.5;
    
    // Disegna il player base centrato con scala 1.5
    draw_sprite_ext(base_sprite, current_frame, player_center_x, player_center_y, preview_scale, preview_scale, image_angle, image_blend, image_alpha);
    
    // Per ora mostra solo il player base (quando il dressing menu sarà riabilitato, 
    // questo codice potrà essere ripristinato per mostrare i vestiti)
    
}