// Riduci cooldown harvest
if (harvest_cooldown > 0) {
    harvest_cooldown--;
}

// Controlla crescita giornaliera
var days_passed = global.game_day - planted_day;
var expected_stage = min(floor(days_passed), max_growth_stage);

if (expected_stage > growth_stage) {
    advance_growth();
}

// Controlla se il player vuole raccogliere
if (can_harvest && harvest_cooldown <= 0) {
    var player = instance_find(obj_player, 0);
    if (player != noone) {
        var dist_to_player = point_distance(x, y, player.x, player.y);
        
        // Se il player è vicino e clicca con tasto destro E non è già stato fatto harvest questo frame
        if (dist_to_player < 32 && mouse_check_button_pressed(mb_right) && !global.harvest_this_frame) {
            // Imposta flag per impedire altri harvest questo frame
            global.harvest_this_frame = true;
            harvest_plant();
        }
    }
}