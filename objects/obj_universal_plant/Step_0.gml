// ===================================================================
// 🌱 UNIVERSAL PLANT - STEP EVENT
// ===================================================================

// Esci se non inizializzato
if (plant_type == "") exit;

// Riduci cooldown harvest
if (harvest_cooldown > 0) {
    harvest_cooldown--;
}

// Controlla crescita giornaliera usando il sistema centralizzato
advance_plant_growth(id);

// Controlla se il player vuole raccogliere
if (can_harvest && harvest_cooldown <= 0) {
    var player = instance_find(obj_player, 0);
    if (player != noone) {
        // Converti coordinate mouse da view a mondo
        var cam = camera_get_active();
        var view_x = camera_get_view_x(cam);
        var view_y = camera_get_view_y(cam);
        var world_mouse_x = mouse_x + view_x;
        var world_mouse_y = mouse_y + view_y;
        
        var dist_to_player = point_distance(x, y, player.x, player.y);
        
        // Se il player è vicino e clicca con tasto destro E non è già stato fatto harvest questo frame
        if (dist_to_player < 32 && mouse_check_button_pressed(mb_right) && !global.harvest_this_frame) {
            // Imposta flag per impedire altri harvest questo frame
            global.harvest_this_frame = true;
            // Usa il sistema centralizzato per harvest
            harvest_plant_universal(id);
        }
    }
}