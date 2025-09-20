// Auto-start the first quest
if (quest_is_available("first_harvest")) {
    quest_start("first_harvest");
    show_debug_message("🎯 Auto-started quest: First Harvest");
}