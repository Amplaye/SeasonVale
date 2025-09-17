// NPC Base - Parent object for all NPCs
// Inherits from obj_depth_sorted like the player

// Initialize NPC variables
npc_id = "";
npc_type = "";
npc_data = {};

// Movement and AI variables
npc_state = "moving"; // Start moving immediately!
npc_speed = 1;
npc_target_x = x + irandom_range(-80, 80); // Set immediate target
npc_target_y = y + irandom_range(-80, 80);
npc_idle_timer = 0; // Start moving right away

// Movement system (like player)
npc_hsp = 0;
npc_vsp = 0;
npc_is_moving = false;
npc_current_direction = "front";

// Pathfinding variables
npc_path = path_add();
npc_path_index = 0;

// Interaction variables
npc_can_talk = true;
npc_talk_range = 32;
npc_is_talking = false;

// Animation variables (using player sprites)
npc_sprite_idle = spr_idle_front;
npc_sprite_walk = spr_run_front; // Will be updated based on direction
npc_direction = 0; // 0=down, 1=left, 2=right, 3=up

// Set the initial sprite
sprite_index = npc_sprite_idle;
image_speed = 1.0; // Same as working right/back sprites (4 fps base)

// Collision mask is set in the object editor (spr_idle_front)

// Ensure sprite origins are correct (like player - bottom center)
// This prevents offset issues when changing direction

// Schedule system
npc_schedule_target = {x: x, y: y};
npc_last_schedule_update = 0;

// Player interaction
npc_player_nearby = false;

// Register this NPC with the manager (will be set by child objects)
// npc_register(id, npc_type); - Called by specific NPC objects