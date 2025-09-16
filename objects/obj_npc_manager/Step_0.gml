// NPC Manager Step - Performance optimized updates

// NPCs now handle their own movement in Step events
// Manager only handles registry cleanup
global.npc_update_timer++;
if (global.npc_update_timer >= global.npc_update_interval) {
    global.npc_update_timer = 0;

    // Only cleanup registry, NPCs handle their own AI
    // if (global.npc_system_active && !global.dialogue_in_progress) {
    //     npc_update_all_npcs();
    // }
}

// Check for NPC cleanup (destroyed instances)
if (global.npc_update_timer mod 120 == 0) { // Every 4 seconds
    npc_cleanup_registry();
}

// Debug info (remove in production)
if (keyboard_check_pressed(vk_f2)) {
    show_debug_message("Active NPCs: " + string(global.npc_count));
    show_debug_message("Dialogue active: " + string(global.dialogue_in_progress));
}