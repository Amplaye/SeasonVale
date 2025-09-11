// ===================================================================
// 🌱 UNIVERSAL PLANT - DRAW EVENT
// ===================================================================

// Disegna la pianta normale
draw_self();

// Esci se non inizializzato
if (plant_type == "") exit;

// Indicatore di harvest se pronta
if (can_harvest && harvest_cooldown <= 0) {
    var player = instance_find(obj_player, 0);
    if (player != noone) {
        // Converti coordinate mouse da view a mondo
        var cam = camera_get_active();
        var view_x = camera_get_view_x(cam);
        var view_y = camera_get_view_y(cam);
        var world_mouse_x = mouse_x + view_x;
        var world_mouse_y = mouse_y + view_y;
        
        var dist_to_plant = point_distance(x, y, world_mouse_x, world_mouse_y);
        var dist_to_player = point_distance(x, y, player.x, player.y);
        
        // Mostra indicatore solo se mouse e player sono vicini
        if (dist_to_plant < 24 && dist_to_player < 48) {
            // Indicatore verde brillante sopra la pianta
            var indicator_x = x;
            var indicator_y = y - sprite_height/2 - 8;
            
            // Effetto pulsante
            var pulse = 0.8 + sin(current_time * 0.01) * 0.2;
            
            draw_set_color(c_lime);
            draw_set_alpha(pulse);
            draw_circle(indicator_x, indicator_y, 3, false);
            draw_set_alpha(1);
            draw_set_color(c_white);
        }
    }
}