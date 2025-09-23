// NPC Base Step - Handled by NPC Manager for performance
// Individual NPCs don't update every frame

// Handle player interaction detection and input
if (npc_can_talk && !global.dialogue_in_progress) {
    var distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);

    if (distance_to_player <= npc_talk_range) {
        npc_player_nearby = true;

        // Check for interaction input (E key only)
        if (keyboard_check_pressed(ord("E"))) {
            // Start dialogue with this NPC
            if (variable_struct_exists(npc_data, "dialogue_id")) {
                dialogue_start(npc_data.dialogue_id, id);
            } else {
                // Default dialogue
                dialogue_start("default_greeting", id);
            }
        }
    } else {
        npc_player_nearby = false;
    }
}

// Handle talking state
if (npc_is_talking) {
    npc_state = "talking";
    npc_speed = 0; // Stop moving when talking
}

// === MOVEMENT SYSTEM (like player) ===
if (!npc_is_talking) {
    // Calculate movement towards target
    var distance_to_target = point_distance(x, y, npc_target_x, npc_target_y);

    var stop_distance = 16; // PARAMETRO CHIAVE: distanza minima per fermarsi
    if (distance_to_target > stop_distance) {
        // Move towards target with speed that won't overshoot
        var move_speed = 1; // Default speed
        if (npc_data != undefined && variable_struct_exists(npc_data, "walk_speed")) {
            var speed_value = npc_data.walk_speed;
            if (speed_value != undefined && is_real(speed_value)) {
                move_speed = speed_value;
            }
        }

        // No deceleration - simple movement like working directions

        var dir_to_target = point_direction(x, y, npc_target_x, npc_target_y);

        npc_hsp = lengthdir_x(move_speed, dir_to_target);
        npc_vsp = lengthdir_y(move_speed, dir_to_target);
        npc_is_moving = true;
        npc_state = "moving";
    } else {
        // Reached target, choose new one after a longer wait
        npc_idle_timer++;
        if (npc_idle_timer > irandom_range(120, 240)) { // Much longer wait
            npc_target_x = x + irandom_range(-80, 80);
            npc_target_y = y + irandom_range(-80, 80);
            npc_idle_timer = 0;
        }
        npc_hsp = 0;
        npc_vsp = 0;
        npc_is_moving = false;
        npc_state = "idle";
    }

    // Apply movement with collision (obj_collision_block includes NPCs automatically, plus player)
    if (npc_hsp != 0) {
        if (!place_meeting(x + npc_hsp, y, obj_collision_block) && !place_meeting(x + npc_hsp, y, obj_player)) {
            x += npc_hsp;
        }
    }
    if (npc_vsp != 0) {
        if (!place_meeting(x, y + npc_vsp, obj_collision_block) && !place_meeting(x, y + npc_vsp, obj_player)) {
            y += npc_vsp;
        }
    }

    // Update direction and sprite (like player system)
    var new_sprite = -1;
    var new_direction = "";

    if (npc_is_moving) {
        // Use same direction bias logic as player to prevent flickering
        if (npc_hsp != 0 && npc_vsp != 0) {
            // Both horizontal and vertical movement - use bias system like player
            if (npc_current_direction == "right" || npc_current_direction == "left") {
                // Currently horizontal - favor horizontal unless vertical is significantly stronger
                if (abs(npc_hsp) >= abs(npc_vsp) * 0.7) {
                    if (npc_hsp > 0) {
                        new_direction = "right";
                        new_sprite = spr_walk_right;
                    } else {
                        new_direction = "left";
                        new_sprite = spr_walk_left;
                    }
                } else {
                    if (npc_vsp > 0) {
                        new_direction = "front";
                        new_sprite = spr_walk_front;
                    } else {
                        new_direction = "back";
                        new_sprite = spr_walk_back;
                    }
                }
            } else {
                // Currently vertical - favor vertical unless horizontal is significantly stronger
                if (abs(npc_vsp) >= abs(npc_hsp) * 0.7) {
                    if (npc_vsp > 0) {
                        new_direction = "front";
                        new_sprite = spr_walk_front;
                    } else {
                        // Special case for back direction - be even more sticky
                        if (npc_current_direction == "back" && npc_vsp < 0 && abs(npc_vsp) > 0.1) {
                            new_direction = "back";
                            new_sprite = spr_walk_back;
                        } else {
                            new_direction = "back";
                            new_sprite = spr_walk_back;
                        }
                    }
                } else {
                    // Only change from back direction if horizontal movement is very strong
                    if (npc_current_direction == "back" && abs(npc_hsp) < abs(npc_vsp) * 2.0) {
                        // Stay in back direction
                        new_direction = "back";
                        new_sprite = spr_walk_back;
                    } else {
                        if (npc_hsp > 0) {
                            new_direction = "right";
                            new_sprite = spr_walk_right;
                        } else {
                            new_direction = "left";
                            new_sprite = spr_walk_left;
                        }
                    }
                }
            }
        } else if (npc_hsp > 0) {
            new_direction = "right";
            new_sprite = spr_walk_right;
        } else if (npc_hsp < 0) {
            new_direction = "left";
            new_sprite = spr_walk_left;
        } else if (npc_vsp > 0) {
            new_direction = "front";
            new_sprite = spr_walk_front;
        } else if (npc_vsp < 0) {
            new_direction = "back";
            new_sprite = spr_walk_back;
        }
        image_speed = 1.0; // Same animation speed as player
    } else {
        // Idle sprites based on current direction
        switch (npc_current_direction) {
            case "right":
                new_sprite = spr_idle_right;
                break;
            case "left":
                new_sprite = spr_idle_left;
                break;
            case "front":
                new_sprite = spr_idle_front;
                break;
            case "back":
                new_sprite = spr_idle_back;
                break;
            default:
                new_sprite = spr_idle_front;
                break;
        }
        image_speed = 1.0; // Same as working right/back sprites (4 fps base)
    }

    // Update sprite and direction with offset management (like player system)
    if (new_sprite != -1 && sprite_index != new_sprite) {
        // Save current visual position before sprite change
        var old_visual_x = x - sprite_get_xoffset(sprite_index);
        var old_visual_y = y - sprite_get_yoffset(sprite_index);

        // Change sprite (simple approach like working right/back sprites)
        sprite_index = new_sprite;
        // Let animation continue naturally

        // Restore visual position with new sprite offset
        x = old_visual_x + sprite_get_xoffset(new_sprite);
        y = old_visual_y + sprite_get_yoffset(new_sprite);
    }
    if (new_direction != "" && npc_current_direction != new_direction) {
        npc_current_direction = new_direction;
    }
} else {
    // Talking - stop movement and animation
    npc_hsp = 0;
    npc_vsp = 0;
    npc_is_moving = false;
    image_speed = 0;
    image_index = 0;
}