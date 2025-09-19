// === TREE STEP EVENT - FINALE ===

// Se morto, distruggi
if (self.health <= 0) {
    // RIMUOVI COLLISION IMMEDIATAMENTE
    solid = false;
    visible = false;
    mask_index = -1;
    sprite_index = -1;

    // Crea drops
    for (var i = 0; i < final_drops; i++) {
        var drop = instance_create_depth(x, y - 40, depth - 10, obj_wood_drop);
        drop.hspeed = random_range(-3, 3);
        drop.vspeed = random_range(-4, -1);
    }

    // DISTRUGGI ANCHE collision_block vicino
    var collision_obj = collision_circle(x, y, 50, obj_collision_block, false, true);
    if (collision_obj != noone) {
        with (collision_obj) {
            instance_destroy();
        }
    }

    // Sposta fuori mappa e distruggi
    x = -10000;
    y = -10000;
    instance_destroy();
    exit;
}

// Shake effect
if (shake_timer > 0) {
    shake_timer--;
    shake_intensity *= 0.85;
}

// Controlla danno dal player
var player = instance_find(obj_player, 0);
if (player != noone) {
    // SOLO se il player sta usando l'ASCIA (tool 0)
    if (variable_instance_exists(player, "is_chopping") && player.is_chopping && global.selected_tool == 0) {
        var my_dist = point_distance(x, y, player.x, player.y);

        // SOLO se questo specifico tree è vicino
        if (my_dist < 50) {
            if (current_time - last_damage_time > 500) {
                self.health--;  // USA SELF
                last_damage_time = current_time;

                // Shake
                shake_timer = 20;
                shake_intensity = 1.2;

                // Drop casuale
                if (random(100) < 50) {
                    var drop = instance_create_depth(x, y - 60, depth - 10, obj_wood_drop);
                    drop.hspeed = random_range(-1.5, 1.5);
                    drop.vspeed = random_range(-2.5, -1);
                }
            }
        }
    }
}