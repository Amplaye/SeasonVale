// Quest Manager Step - Monitor quest progress

quest_update_timer++;

if (quest_update_timer >= quest_update_interval) {
    quest_update_timer = 0;

    // Check progress for all active quests
    quest_check_all_progress();
}

// Debug controls (remove in production)
if (keyboard_check_pressed(vk_f3)) {
    var active_count = ds_map_size(global.active_quests);
    var completed_count = ds_list_size(global.completed_quests);
    show_debug_message("Active Quests: " + string(active_count));
    show_debug_message("Completed Quests: " + string(completed_count));
}