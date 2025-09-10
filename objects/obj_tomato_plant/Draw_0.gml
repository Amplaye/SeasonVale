// Disegna la pianta
draw_self();

// Indicatore di harvest se pronta
if (can_harvest && harvest_cooldown <= 0) {
    var player = instance_find(obj_player, 0);
    if (player != noone) {
        var dist_to_player = point_distance(x, y, player.x, player.y);
        
        if (dist_to_player < 64) {
            // Indicatore tasto destro sopra la pianta
            draw_set_font(-1);
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            
            // Ombra
            draw_set_color(c_black);
            draw_text(x + 1, y - sprite_height/2 - 9, "RMB");
            
            // Testo principale
            draw_set_color(c_white);
            draw_text(x, y - sprite_height/2 - 10, "RMB");
            
            // Reset draw settings
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
        }
    }
}