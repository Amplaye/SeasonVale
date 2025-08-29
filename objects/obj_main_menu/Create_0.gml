visible = false;
depth = -1000;

current_page_index = 0;

// Tutti i mark objects disponibili
mark_objects = [
    obj_mark_settings,
    obj_mark_map, 
    obj_mark_npc,
    obj_mark_stats,
    obj_mark_help,
    obj_mark_animals,
    obj_mark_crafting,
    obj_mark_potions,
    obj_mark_scrolls
];

// Player preview collegato solo a stats
player_preview_object = obj_player_preview;