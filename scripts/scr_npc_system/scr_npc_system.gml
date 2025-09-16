// NPC System - Core functions for NPC management
// All NPC-related functions and utilities

// Initialize NPC data from external files
function npc_load_database() {
    // Default NPC data - will be loaded from JSON files later
    global.npc_database = {
        "farmer": {
            "name": "Old Tom",
            "sprite": spr_idle_front, // Using player sprite
            "walk_speed": 0.8,
            "idle_time": 120, // 2 seconds at 60fps
            "dialogue_id": "farmer_intro",
            "schedule": {
                "morning": {x: 100, y: 100},
                "afternoon": {x: 150, y: 120},
                "evening": {x: 80, y: 90}
            }
        },
        "merchant": {
            "name": "Trader Joe",
            "sprite": spr_idle_front,
            "walk_speed": 0.6,
            "idle_time": 180,
            "dialogue_id": "merchant_intro",
            "schedule": {
                "morning": {x: 200, y: 150},
                "afternoon": {x: 200, y: 150},
                "evening": {x: 180, y: 140}
            }
        },
        "villager": {
            "name": "Sarah",
            "sprite": spr_idle_front,
            "walk_speed": 1.0,
            "idle_time": 100,
            "dialogue_id": "villager_intro",
            "schedule": {
                "morning": {x: 300, y: 200},
                "afternoon": {x: 280, y: 180},
                "evening": {x: 320, y: 220}
            }
        }
    };
}

// Register a new NPC in the system
function npc_register(npc_instance, npc_type) {
    var npc_id = "npc_" + string(global.npc_count);
    ds_map_add(global.npc_registry, npc_id, npc_instance);

    // Set NPC instance variables
    npc_instance.npc_id = npc_id;
    npc_instance.npc_type = npc_type;
    npc_instance.npc_data = global.npc_database[$ npc_type];

    global.npc_count++;
    return npc_id;
}

// Unregister an NPC (when destroyed)
function npc_unregister(npc_id) {
    if (ds_map_exists(global.npc_registry, npc_id)) {
        ds_map_delete(global.npc_registry, npc_id);
        global.npc_count--;
    }
}

// Update all NPCs with performance optimization
function npc_update_all_npcs() {
    var npc_id = ds_map_find_first(global.npc_registry);
    var updated_count = 0;

    while (!is_undefined(npc_id)) {
        var npc_instance = ds_map_find_value(global.npc_registry, npc_id);

        if (instance_exists(npc_instance)) {
            // Distance-based LOD
            var distance_to_player = point_distance(
                npc_instance.x, npc_instance.y,
                obj_player.x, obj_player.y
            );

            if (distance_to_player < global.npc_lod_distance) {
                npc_update_behavior(npc_instance);
                updated_count++;
            } else {
                // Simple update for distant NPCs
                npc_simple_update(npc_instance);
            }
        }

        npc_id = ds_map_find_next(global.npc_registry, npc_id);
    }

    // Limit updates per frame to maintain performance
    if (updated_count > 2) {
        global.npc_update_interval = 45; // Slow down if too many active
    } else {
        global.npc_update_interval = 30; // Normal speed
    }
}

// Update NPC behavior (for close NPCs)
function npc_update_behavior(npc_instance) {
    with (npc_instance) {
        // Update AI state machine
        switch (npc_state) {
            case "idle":
                npc_idle_timer--;
                if (npc_idle_timer <= 0) {
                    npc_choose_new_target();
                    npc_state = "moving";
                }
                break;

            case "moving":
                if (npc_move_to_target()) {
                    npc_state = "idle";
                    npc_idle_timer = npc_data.idle_time + irandom(60);
                }
                break;

            case "talking":
                // Handle dialogue state (managed by dialogue system)
                break;
        }
    }
}

// Simple update for distant NPCs
function npc_simple_update(npc_instance) {
    with (npc_instance) {
        // Just update position towards schedule target
        var schedule = npc_get_current_schedule_target();
        if (schedule != undefined) {
            x = lerp(x, schedule.x, 0.01);
            y = lerp(y, schedule.y, 0.01);
        }
    }
}

// Clean up registry of destroyed instances
function npc_cleanup_registry() {
    var npc_id = ds_map_find_first(global.npc_registry);
    var to_remove = [];

    while (!is_undefined(npc_id)) {
        var npc_instance = ds_map_find_value(global.npc_registry, npc_id);

        if (!instance_exists(npc_instance)) {
            array_push(to_remove, npc_id);
        }

        npc_id = ds_map_find_next(global.npc_registry, npc_id);
    }

    // Remove invalid entries
    for (var i = 0; i < array_length(to_remove); i++) {
        ds_map_delete(global.npc_registry, to_remove[i]);
        global.npc_count--;
    }
}

// Get NPC by ID
function npc_get_by_id(npc_id) {
    if (ds_map_exists(global.npc_registry, npc_id)) {
        return ds_map_find_value(global.npc_registry, npc_id);
    }
    return noone;
}

// Get all NPCs of a specific type
function npc_get_all_of_type(npc_type) {
    var result = [];
    var npc_id = ds_map_find_first(global.npc_registry);

    while (!is_undefined(npc_id)) {
        var npc_instance = ds_map_find_value(global.npc_registry, npc_id);

        if (instance_exists(npc_instance) && npc_instance.npc_type == npc_type) {
            array_push(result, npc_instance);
        }

        npc_id = ds_map_find_next(global.npc_registry, npc_id);
    }

    return result;
}

// NPC Movement and Pathfinding Functions

// Make NPC choose a new target location
function npc_choose_new_target() {
    // Get current schedule target
    var schedule_target = npc_get_current_schedule_target();

    if (schedule_target != undefined) {
        npc_target_x = schedule_target.x + irandom_range(-30, 30);
        npc_target_y = schedule_target.y + irandom_range(-30, 30);
    } else {
        // Random movement around current position
        npc_target_x = x + irandom_range(-50, 50);
        npc_target_y = y + irandom_range(-50, 50);
    }

    // Update direction based on target
    npc_update_direction();
}

// Move NPC towards target (returns true when reached)
function npc_move_to_target() {
    var distance_to_target = point_distance(x, y, npc_target_x, npc_target_y);

    if (distance_to_target > 4) {
        // Simple pathfinding - move towards target
        var move_x = sign(npc_target_x - x) * npc_data.walk_speed;
        var move_y = sign(npc_target_y - y) * npc_data.walk_speed;

        // Check for collisions (using tilemap like player)
        if (!tilemap_get_at_pixel(tilemap, x + move_x, y)) {
            x += move_x;
        }
        if (!tilemap_get_at_pixel(tilemap, x, y + move_y)) {
            y += move_y;
        }

        return false;
    }

    return true; // Reached target
}

// Update NPC sprite direction based on movement
function npc_update_direction() {
    var dir_x = npc_target_x - x;
    var dir_y = npc_target_y - y;

    if (abs(dir_x) > abs(dir_y)) {
        npc_direction = (dir_x > 0) ? 2 : 1; // Right or Left
    } else {
        npc_direction = (dir_y > 0) ? 0 : 3; // Down or Up
    }
}

// Get current schedule target based on time
function npc_get_current_schedule_target() {
    if (!variable_struct_exists(npc_data, "schedule")) {
        return undefined;
    }

    var game_hour = global.game_hour ?? 12; // Default to noon
    var time_period = "morning";

    if (game_hour >= 6 && game_hour < 12) {
        time_period = "morning";
    } else if (game_hour >= 12 && game_hour < 18) {
        time_period = "afternoon";
    } else {
        time_period = "evening";
    }

    return npc_data.schedule[$ time_period];
}