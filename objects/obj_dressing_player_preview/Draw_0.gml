if (visible && obj_dressing_menu.visible) {
    var menu = obj_dressing_menu;
    
    current_frame += frame_speed / game_get_speed(gamespeed_fps);
    if (current_frame >= sprite_get_number(base_sprite)) {
        current_frame = 0;
    }
    
    // Calcola posizione centrata del player
    var player_center_x = x;
    var player_center_y = y;
    
    // Scala fissa a 1.5 per il player preview
    var preview_scale = 1.5;
    
    // Disegna il player base centrato con scala 1.5
    draw_sprite_ext(base_sprite, current_frame, player_center_x, player_center_y, preview_scale, preview_scale, image_angle, image_blend, image_alpha);
    
    // Ordine di disegno: prima i vestiti di base, poi i capelli, infine il cappello sopra
    var pants_spr = menu.pants_sprites[menu.current_pants_index];
    if (pants_spr != noone) {
        draw_sprite_ext(pants_spr, current_frame, player_center_x, player_center_y, preview_scale, preview_scale, image_angle, image_blend, image_alpha);
    }
    
    var shirt_spr = menu.shirt_sprites[menu.current_shirt_index];
    if (shirt_spr != noone) {
        draw_sprite_ext(shirt_spr, current_frame, player_center_x, player_center_y, preview_scale, preview_scale, image_angle, image_blend, image_alpha);
    }
    
    var hair_spr = menu.hair_sprites[menu.current_hair_index];
    if (hair_spr != noone) {
        draw_sprite_ext(hair_spr, current_frame, player_center_x, player_center_y, preview_scale, preview_scale, image_angle, image_blend, image_alpha);
    }
    
    // Cappello disegnato per ultimo = sopra a tutto
    var hat_spr = menu.hat_sprites[menu.current_hat_index];
    if (hat_spr != noone) {
        draw_sprite_ext(hat_spr, current_frame, player_center_x, player_center_y, preview_scale, preview_scale, image_angle, image_blend, image_alpha);
    }
    
}