visible = false;  // Controllato dal sistema di menu
depth = -15000; // Menu deve essere sopra tutto (layer Meta)

// Inizializza ottimizzazioni performance per Mac M2
// initialize_performance_optimizations(); // Temporary comment to fix build

// Frame counter per performance tracking
alarm[0] = 1;

// Forza GameMaker a includere gli sprite nella compilazione
sprite_add_to_cache = [spr_menu_basic, spr_menu_stats];

current_page_index = 0;

// Variabili per ottimizzazione check sprite (evita check ogni frame)
sprite_check_counter = 0;
cached_menu_sprite = spr_menu_basic;

// Variabile per gestione cursore
cursor_already_set = false;

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