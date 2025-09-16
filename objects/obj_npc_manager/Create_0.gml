// NPC Manager - Core system for managing all NPCs
// Persistent object that tracks all NPC instances and coordinates systems

// NPC Registry - stores all active NPCs
global.npc_registry = ds_map_create();
global.npc_count = 0;

// Performance settings
global.npc_update_timer = 0;
global.npc_update_interval = 30; // Update NPCs every 30 frames
global.npc_lod_distance = 200; // Distance for Level of Detail

// System status
global.npc_system_active = true;
global.dialogue_in_progress = false;

// Initialize NPC data if not loaded
if (!variable_global_exists("npc_data_loaded")) {
    npc_load_database();
    global.npc_data_loaded = true;
}

// Initialize debug mode (use a different variable name)
global.npc_debug_mode = true; // Set to false in production

show_debug_message("NPC Manager initialized - System ready");