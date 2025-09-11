// ===================================================================
// 🌰 TOOLBAR SEEDS - GESTIONE SEMI NELLA TOOLBAR
// ===================================================================
// Sistema per aggiungere e gestire i semi nella toolbar

// Aggiunge tutti i semi disponibili alla toolbar (per testing)
function add_all_seeds_to_toolbar() {
    var seed_sprites = get_available_seeds();
    var slot = 4; // Inizia dallo slot 5 (indice 4)
    
    for (var i = 0; i < array_length(seed_sprites) && slot < global.toolbar_slots_count; i++) {
        var seed_sprite = seed_sprites[i];
        
        // Aggiungi seme alla toolbar
        global.tool_sprites[slot] = seed_sprite;
        global.tool_quantities[slot] = 10; // 10 semi per tipo
        
        // Validazione sprite e debug message
        if (sprite_exists(seed_sprite)) {
            show_debug_message("🌰 Added " + sprite_get_name(seed_sprite) + " x10 to toolbar slot " + string(slot + 1));
        } else {
            show_debug_message("🌰 Added seed x10 to toolbar slot " + string(slot + 1) + " (ID:" + string(seed_sprite) + ")");
        }
        slot++;
    }
    
    return slot - 4; // Numero di semi aggiunti
}

// Aggiunge un seme specifico alla toolbar
function add_seed_to_toolbar(plant_type, quantity = 10) {
    var seed_sprite = get_seed_sprite_for_plant(plant_type);
    if (seed_sprite == noone) {
        show_debug_message("❌ Cannot add seed for plant type: " + plant_type);
        return false;
    }
    
    return toolbar_add_item(seed_sprite, quantity);
}

// Rimuovi tutti i semi dalla toolbar
function remove_all_seeds_from_toolbar() {
    var seed_sprites = get_available_seeds();
    var removed_count = 0;
    
    for (var slot = 0; slot < global.toolbar_slots_count; slot++) {
        var current_sprite = global.tool_sprites[slot];
        
        // Controlla se questo slot contiene un seme
        for (var i = 0; i < array_length(seed_sprites); i++) {
            if (current_sprite == seed_sprites[i]) {
                global.tool_sprites[slot] = noone;
                global.tool_quantities[slot] = 0;
                removed_count++;
                break;
            }
        }
    }
    
    show_debug_message("🌰 Removed " + string(removed_count) + " seed types from toolbar");
    return removed_count;
}

// Ottieni tutti i semi attualmente nella toolbar
function get_seeds_in_toolbar() {
    var seeds_in_toolbar = [];
    
    for (var slot = 0; slot < global.toolbar_slots_count; slot++) {
        var current_sprite = global.tool_sprites[slot];
        if (current_sprite != noone && is_valid_seed(current_sprite)) {
            array_push(seeds_in_toolbar, {
                sprite: current_sprite,
                quantity: global.tool_quantities[slot],
                slot: slot
            });
        }
    }
    
    return seeds_in_toolbar;
}

show_debug_message("🌰 Toolbar Seeds System loaded successfully!");