// ===================================================================
// 🌱 PLANT SYSTEM - SISTEMA CENTRALIZZATO GESTIONE PIANTE
// ===================================================================
// Gestisce configurazioni, crescita e harvest di tutte le piante
// Facilita l'aggiunta di nuove piante senza duplicare codice

// ===== CONFIGURAZIONI PIANTE =====
// Definisce le proprietà di ogni tipo di pianta

function get_plant_configs() {
    static plant_configs = undefined;
    
    plant_configs ??= {
            // POMODORI
            "tomato": {
                sprite: spr_tomatoes,
                max_growth_stage: 4,
                days_to_grow: 5,
                harvest_amount: 3,
                harvest_item: spr_tomato,
                harvest_cooldown_frames: 30,
                reset_stage_after_harvest: 3, // Reset a stadio 0 per differenza visiva più marcata
                depth: 3,
                can_regrow: true,  // Se può essere raccolta più volte
                description: "Pomodori succosi e rossi"
            },
            
            // CAROTE (usa sprite tomatoes come placeholder temporaneo)
            "carrot": {
                sprite: spr_tomatoes,  // Placeholder temporaneo
                max_growth_stage: 3,
                days_to_grow: 3,
                harvest_amount: 2,
                harvest_item: spr_carrot,
                harvest_cooldown_frames: 45,
                reset_stage_after_harvest: -1, // -1 = distruggi pianta dopo harvest
                depth: 3,
                can_regrow: false,
                description: "Carote croccanti e arancioni"
            }
        };
    
    return plant_configs;
}

// ===== FUNZIONI UTILITY PIANTE =====

// Ottieni configurazione di una pianta
function get_plant_config(plant_type) {
    var configs = get_plant_configs();
    if (variable_struct_exists(configs, plant_type)) {
        return configs[$ plant_type];
    }
    
    show_debug_message("⚠️ Plant config non trovato per: " + plant_type);
    return undefined;
}

// Inizializza una pianta con le sue configurazioni
function init_plant(plant_type, instance_id) {
    var config = get_plant_config(plant_type);
    if (config == undefined) return false;
    
    with (instance_id) {
        // Imposta variabili dalla configurazione
        self.plant_type = plant_type;
        self.growth_stage = 0;
        self.max_growth_stage = config.max_growth_stage;
        self.days_to_grow = config.days_to_grow;
        self.planted_day = global.game_day;
        
        self.can_harvest = false;
        self.harvest_cooldown = 0;
        self.harvest_amount = config.harvest_amount;
        self.harvest_item = config.harvest_item;
        self.harvest_cooldown_frames = config.harvest_cooldown_frames;
        self.reset_stage_after_harvest = config.reset_stage_after_harvest;
        self.can_regrow = config.can_regrow;
        
        // Imposta sprite e frame
        sprite_index = config.sprite;
        image_index = self.growth_stage;
        image_speed = 0;
        depth = config.depth;
        
        show_debug_message("🌱 " + string_upper(plant_type) + " plant created - Stage: " + string(self.growth_stage) + " Day: " + string(self.planted_day));
    }
    
    return true;
}

// Avanza crescita di una pianta
function advance_plant_growth(instance_id) {
    with (instance_id) {
        if (!variable_instance_exists(id, "plant_type")) return false;
        
        var days_passed = global.game_day - planted_day;
        var expected_stage = min(floor(days_passed), max_growth_stage);
        
        if (expected_stage > growth_stage) {
            growth_stage = expected_stage;
            image_index = growth_stage;
            
            // Se raggiunge l'ultimo stadio, può essere raccolta
            if (growth_stage >= max_growth_stage) {
                can_harvest = true;
                show_debug_message("🌻 " + string_upper(plant_type) + " ready for harvest!");
            }
            
            show_debug_message("🌱 " + string_upper(plant_type) + " grown to stage " + string(growth_stage));
            return true;
        }
    }
    return false;
}

// Raccogli una pianta
function harvest_plant_universal(instance_id) {
    with (instance_id) {
        if (!variable_instance_exists(id, "plant_type")) return false;
        if (!can_harvest || harvest_cooldown > 0) return false;
        
        // Aggiungi item alla toolbar attraverso l'istanza obj_toolbar
        var toolbar_instance = instance_find(obj_toolbar, 0);
        var success = false;
        
        if (toolbar_instance != noone) {
            success = toolbar_instance.toolbar_add_item(harvest_item, harvest_amount);
            if (success) {
                show_debug_message("🌾 Harvested " + string(harvest_amount) + "x " + sprite_get_name(harvest_item) + " - Added to toolbar");
            } else {
                show_debug_message("⚠️ Harvest failed - Toolbar full! " + string(harvest_amount) + "x " + sprite_get_name(harvest_item) + " lost");
            }
        } else {
            show_debug_message("⚠️ Harvest failed - No toolbar instance found!");
        }
        
        // Gestisci post-harvest
        if (reset_stage_after_harvest == -1) {
            // Distruggi pianta (piante una-tantum)
            show_debug_message("🗑️ " + string_upper(plant_type) + " plant destroyed after harvest");
            
            // Trova e resetta il tilled_soil associato
            var soil = instance_nearest(x, y, obj_tilled_soil);
            if (soil != noone && point_distance(x, y, soil.x, soil.y) < 16) {
                soil.has_seed = false;
                soil.planted_seed_type = noone;
                soil.plant_instance = noone;
                show_debug_message("🟫 Tilled soil reset - ready for replanting");
            }
            
            instance_destroy();
            return true;
        } else {
            // Reset a stadio specifico (piante che ricrescono)
            growth_stage = reset_stage_after_harvest;
            can_harvest = false;
            harvest_cooldown = harvest_cooldown_frames;
            
            // Aggiornamento visivo con verifica sicurezza
            if (reset_stage_after_harvest >= 0 && reset_stage_after_harvest < sprite_get_number(sprite_index)) {
                image_index = reset_stage_after_harvest;
            } else {
                image_index = 0; // Fallback sicuro
            }
            
            image_speed = 0; // Ferma l'animazione
            
            // Forza refresh visivo e aggiorna planted_day per reset crescita
            planted_day = global.game_day - reset_stage_after_harvest;
            
            show_debug_message("🔄 " + string_upper(plant_type) + " plant reset to stage " + string(reset_stage_after_harvest));
            show_debug_message("🎨 VISUAL UPDATE: frame " + string(image_index) + "/" + string(sprite_get_number(sprite_index)-1) + ", planted_day reset to " + string(planted_day));
            return true;
        }
    }
    return false;
}

// Ottieni lista di tutti i tipi di piante disponibili
function get_available_plant_types() {
    var configs = get_plant_configs();
    return variable_struct_get_names(configs);
}

// Ottieni sprite del seme per un tipo di pianta
function get_seed_sprite_for_plant(plant_type) {
    var config = get_plant_config(plant_type);
    if (config != undefined && sprite_exists(config.harvest_item)) {
        return config.harvest_item; // Per ora usa l'item raccolto come seme
    }
    return noone;
}

// ===== FUNZIONI DEBUG =====

// Stampa informazioni di tutte le piante
function debug_print_all_plants() {
    var configs = get_plant_configs();
    var plant_types = variable_struct_get_names(configs);
    
    show_debug_message("🌱 === PLANT SYSTEM DEBUG ===");
    show_debug_message("Total plant types: " + string(array_length(plant_types)));
    
    for (var i = 0; i < array_length(plant_types); i++) {
        var type = plant_types[i];
        var config = configs[$ type];
        show_debug_message("  - " + string_upper(type) + ": " + string(config.max_growth_stage + 1) + " stages, " + string(config.days_to_grow) + " days, " + string(config.harvest_amount) + "x harvest");
    }
}

// Stampa stato di una pianta specifica
function debug_print_plant_status(instance_id) {
    with (instance_id) {
        if (!variable_instance_exists(id, "plant_type")) {
            show_debug_message("❌ Not a plant instance");
            return;
        }
        
        show_debug_message("🌱 === " + string_upper(plant_type) + " STATUS ===");
        show_debug_message("  Growth: " + string(growth_stage) + "/" + string(max_growth_stage));
        show_debug_message("  Days planted: " + string(global.game_day - planted_day));
        show_debug_message("  Can harvest: " + string(can_harvest));
        show_debug_message("  Cooldown: " + string(harvest_cooldown));
    }
}

show_debug_message("🌱 Plant System loaded successfully!");