// ===================================================================
// 🌰 SEED SYSTEM - SISTEMA GESTIONE SEMI
// ===================================================================
// Mappa i semi ai tipi di piante e gestisce la logica di piantatura

// ===== MAPPATURA SEMI -> PIANTE =====
function get_seed_to_plant_mapping() {
    static seed_mapping = undefined;
    
    if (seed_mapping == undefined) {
        seed_mapping = ds_map_create();
        // Sprite del seme -> tipo di pianta (solo tipi configurati)
        ds_map_add(seed_mapping, spr_tomato, "tomato");
        ds_map_add(seed_mapping, spr_carrot, "carrot");
    }
    
    return seed_mapping;
}

// Ottieni tipo di pianta da sprite del seme
function get_plant_type_from_seed(seed_sprite) {
    var mapping = get_seed_to_plant_mapping();
    
    if (ds_map_exists(mapping, seed_sprite)) {
        return ds_map_find_value(mapping, seed_sprite);
    }
    
    // Rimuovi warning per tool che non sono semi (come spr_hoe, spr_axe, etc.)
    return undefined;
}

// Controlla se uno sprite è un seme valido
function is_valid_seed(seed_sprite) {
    var plant_type = get_plant_type_from_seed(seed_sprite);
    return (plant_type != undefined);
}

// Ottieni lista di tutti i semi disponibili
function get_available_seeds() {
    var mapping = get_seed_to_plant_mapping();
    var sprites = [];
    
    // Per ds_map, iteriamo direttamente sui valori noti
    var key = ds_map_find_first(mapping);
    while (!is_undefined(key)) {
        if (sprite_exists(key)) {
            array_push(sprites, key);
        }
        key = ds_map_find_next(mapping, key);
    }
    
    return sprites;
}

// Pianta un seme in una posizione specifica
function plant_seed_at_position(seed_sprite, pos_x, pos_y) {
    var plant_type = get_plant_type_from_seed(seed_sprite);
    if (plant_type == undefined) {
        show_debug_message("❌ Cannot plant invalid seed: " + sprite_get_name(seed_sprite));
        return noone;
    }
    
    // Crea la pianta universale
    var plant_instance = instance_create_depth(pos_x, pos_y, 3, obj_universal_plant);
    
    // Inizializza con il tipo corretto
    var success = init_plant(plant_type, plant_instance);
    
    if (success) {
        show_debug_message("🌱 Successfully planted " + plant_type + " seed at " + string(pos_x) + ", " + string(pos_y));
        return plant_instance;
    } else {
        // Se l'inizializzazione fallisce, distruggi l'istanza
        instance_destroy(plant_instance);
        show_debug_message("❌ Failed to initialize plant: " + plant_type);
        return noone;
    }
}

show_debug_message("🌰 Seed System loaded successfully!");