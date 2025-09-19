// === DIRECTIONAL TRANSITION SYSTEM ===

if (instance_exists(obj_player)) {
    var player = instance_find(obj_player, 0);
    var player_feet_x = player.x;
    var player_feet_y = player.y;

    // Controlla se il player è sulla transition
    if (collision_point(player_feet_x, player_feet_y, id, false, false) && !global.transitioning) {

        // Determina la direzione del movimento del player
        var player_moving_direction = "";

        if (player.is_moving) {
            // Calcola la direzione basata su velocità
            if (abs(player.hsp) > abs(player.vsp)) {
                // Movimento prevalentemente orizzontale
                if (player.hsp > 0) {
                    player_moving_direction = "right";
                } else {
                    player_moving_direction = "left";
                }
            } else {
                // Movimento prevalentemente verticale
                if (player.vsp > 0) {
                    player_moving_direction = "down";
                } else {
                    player_moving_direction = "up";
                }
            }
        } else {
            // Player non si muove, non attivare transition
            exit;
        }

        // Controlla se la direzione è quella richiesta
        var should_activate = false;

        if (requiredDirection == "any") {
            should_activate = true;
        } else if (requiredDirection == player_moving_direction) {
            should_activate = true;
        }

        // Debug message per testing
        show_debug_message("🚪 Transition: Player moving " + player_moving_direction + ", required: " + requiredDirection + ", activate: " + string(should_activate));

        // Attiva transizione solo se direzione corretta
        if (should_activate) {
            global.transitioning = true;

            // Salva lo stato della room corrente prima di uscire
            save_room_objects(room);

            player.target_x = targetX;
            player.target_y = targetY;
            player.has_transition_target = true;
            room_goto(targetRoom);
        }
    }
}