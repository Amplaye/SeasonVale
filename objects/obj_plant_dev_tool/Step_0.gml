// ===================================================================
// 🛠️ PLANT DEVELOPMENT TOOL - STEP EVENT
// ===================================================================

// Toggle dev mode
if (keyboard_check_pressed(ord("P"))) {
    dev_mode_active = !dev_mode_active;
    show_debug_message("🛠️ Plant dev mode: " + (dev_mode_active ? "ON" : "OFF"));
}

// Solo se dev mode è attivo
if (!dev_mode_active) exit;

// Toggle info display
if (keyboard_check_pressed(ord("I"))) {
    show_plant_info = !show_plant_info;
    show_debug_message("🛠️ Plant info display: " + (show_plant_info ? "ON" : "OFF"));
}

// Crea piante di test
if (keyboard_check_pressed(ord("C"))) {
    create_test_plants();
}

// Forza crescita di tutte le piante
if (keyboard_check_pressed(ord("G"))) {
    force_grow_all_plants();
}

// Harvest tutte le piante pronte
if (keyboard_check_pressed(ord("H"))) {
    harvest_all_ready_plants();
}

// Rimuovi tutte le piante
if (keyboard_check_pressed(ord("R"))) {
    remove_all_plants();
}

// Debug configurazioni
if (keyboard_check_pressed(ord("D"))) {
    debug_print_all_plants();
}

// Aggiungi tutti i semi alla toolbar
if (keyboard_check_pressed(ord("S"))) {
    var added = add_all_seeds_to_toolbar();
    show_debug_message("🛠️ Added " + string(added) + " seed types to toolbar");
}

// Rimuovi tutti i semi dalla toolbar
if (keyboard_check_pressed(ord("X"))) {
    remove_all_seeds_from_toolbar();
}

// Rifornisci semi esistenti
if (keyboard_check_pressed(ord("M"))) {
    refill_existing_seeds();
}

// Compra starter pack di semi
if (keyboard_check_pressed(ord("B"))) {
    buy_starter_seeds_pack();
}

// ===== FUNZIONI TOOL =====

// Crea piante di test
function create_test_plants() {
    show_debug_message("🛠️ Creating test plants...");
    
    for (var i = 0; i < array_length(test_plants); i++) {
        var test_plant = test_plants[i];
        var plant_sprite = get_seed_sprite_for_plant(test_plant.type);
        
        if (plant_sprite != noone) {
            var plant = plant_seed_at_position(plant_sprite, test_plant.x, test_plant.y);
            if (plant != noone) {
                show_debug_message("  ✓ " + test_plant.type + " created at " + string(test_plant.x) + ", " + string(test_plant.y));
            }
        } else {
            show_debug_message("  ❌ Failed to create " + test_plant.type + " - no seed sprite found");
        }
    }
}

// Forza crescita di tutte le piante
function force_grow_all_plants() {
    var count = 0;
    with (obj_universal_plant) {
        if (plant_type != "") {
            if (growth_stage < max_growth_stage) {
                growth_stage++;
                image_index = growth_stage;
                
                if (growth_stage >= max_growth_stage) {
                    can_harvest = true;
                }
                count++;
            }
        }
    }
    show_debug_message("🛠️ Forced growth on " + string(count) + " plants");
}

// Harvest tutte le piante pronte
function harvest_all_ready_plants() {
    var count = 0;
    with (obj_universal_plant) {
        if (can_harvest && harvest_cooldown <= 0) {
            harvest_plant_universal(id);
            count++;
        }
    }
    show_debug_message("🛠️ Harvested " + string(count) + " plants");
}

// Rimuovi tutte le piante
function remove_all_plants() {
    var count = instance_number(obj_universal_plant);
    with (obj_universal_plant) {
        instance_destroy();
    }
    show_debug_message("🛠️ Removed " + string(count) + " universal plants");
    
    // Anche vecchie piante di pomodoro per compatibilità
    count = instance_number(obj_tomato_plant);
    with (obj_tomato_plant) {
        instance_destroy();
    }
    show_debug_message("🛠️ Removed " + string(count) + " tomato plants");
}

// Rifornisci semi esistenti nella toolbar
function refill_existing_seeds() {
    var refilled = 0;
    
    for (var slot = 0; slot < global.toolbar_slots_count; slot++) {
        var current_sprite = global.tool_sprites[slot];
        if (current_sprite != noone && is_valid_seed(current_sprite)) {
            var old_quantity = global.tool_quantities[slot];
            global.tool_quantities[slot] = 20; // Rifornisci con 20 semi
            refilled++;
            show_debug_message("🌰 Refilled slot " + string(slot + 1) + ": " + string(old_quantity) + " → 20");
        }
    }
    
    show_debug_message("🛠️ Refilled " + string(refilled) + " seed slots");
}

// Compra starter pack di semi
function buy_starter_seeds_pack() {
    show_debug_message("🛒 Buying starter seeds pack...");
    
    // Aggiungi semi di pomodoro se non li hai
    if (!toolbar_add_item(spr_tomato, 15)) {
        show_debug_message("  ❌ Could not add tomato seeds");
    } else {
        show_debug_message("  ✅ Added 15x tomato seeds");
    }
    
    // Aggiungi semi di carota se non li hai  
    if (!toolbar_add_item(spr_carrot, 10)) {
        show_debug_message("  ❌ Could not add carrot seeds");
    } else {
        show_debug_message("  ✅ Added 10x carrot seeds");
    }
    
    show_debug_message("🛠️ Starter pack purchased!");
}