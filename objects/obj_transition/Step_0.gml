if (instance_exists(obj_player)) {
    var player = instance_find(obj_player, 0);
    var player_feet_x = player.x;
    var player_feet_y = player.y;

    if (collision_point(player_feet_x, player_feet_y, id, false, false) && !global.transitioning) {
        global.transitioning = true;

        // Salva lo stato della room corrente prima di uscire
        save_room_objects(room);

        player.target_x = targetX;
        player.target_y = targetY;
        player.has_transition_target = true;
        room_goto(targetRoom);
    }
}