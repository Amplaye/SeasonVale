// Quest Manager - Handles all quest systems

depth = -5000; // Quest manager - layer Meta

// Active quests storage
global.active_quests = ds_map_create();
global.completed_quests = ds_list_create();

// Quest tracking variables
quest_update_timer = 0;
quest_update_interval = 60; // Check quest progress every second

// Initialize quest database
if (!variable_global_exists("quest_data_loaded")) {
    quest_load_database();
    global.quest_data_loaded = true;
}

show_debug_message("Quest Manager initialized - Ready for adventure!");