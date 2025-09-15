// ===================================================================
// 🗃️ SISTEMA DI SALVATAGGIO ROOM - SCALABILE E PERFORMANTE
// ===================================================================

// Funzione generica per salvare lo stato di qualsiasi room
function save_room_objects(room_id) {
    var room_key = "room_" + string(room_id) + "_plants";

    // Inizializza array per questa room
    variable_global_set(room_key, []);
    var room_plants = variable_global_get(room_key);

    // Salva tempo globale (condiviso tra tutte le room)
    global.saved_game_day = global.game_day;
    global.saved_game_hour = global.game_hour;
    global.saved_game_minute = global.game_minute;

    // Salva tutte le piante in questa room
    with (obj_universal_plant) {
        var plant_data = {
            x: x,
            y: y,
            plant_type: plant_type,
            growth_stage: growth_stage,
            max_growth_stage: max_growth_stage,
            planted_day: planted_day,
            can_harvest: can_harvest,
            sprite_index: sprite_index,
            image_index: image_index,
            last_growth_check_day: last_growth_check_day,
            is_loaded_from_save: true
        };
        array_push(room_plants, plant_data);
    }

    with (obj_tomato_plant) {
        var plant_data = {
            x: x,
            y: y,
            growth_stage: growth_stage,
            max_growth_stage: max_growth_stage,
            planted_day: planted_day,
            can_harvest: can_harvest,
            sprite_index: sprite_index,
            image_index: image_index,
            last_growth_check_day: last_growth_check_day,
            object_type: "tomato_plant",
            is_loaded_from_save: true
        };
        array_push(room_plants, plant_data);
    }

    // Aggiorna la variabile globale
    variable_global_set(room_key, room_plants);
}

// Funzione generica per caricare lo stato di qualsiasi room
function load_room_objects(room_id) {
    var room_key = "room_" + string(room_id) + "_plants";

    if (!variable_global_exists(room_key)) return;

    // Ripristina il tempo salvato se disponibile (solo una volta)
    if (variable_global_exists("saved_game_day") && !variable_global_exists("time_restored")) {
        global.game_day = global.saved_game_day;
        global.game_hour = global.saved_game_hour;
        global.game_minute = global.saved_game_minute;
        global.time_restored = true;

        // Aggiorna overlay tempo
        if (instance_exists(obj_time_manager)) {
            with (obj_time_manager) {
                update_time_overlay();
            }
        }
    }

    var room_plants = variable_global_get(room_key);
    var plant_count = array_length(room_plants);

    for (var i = 0; i < plant_count; i++) {
        var plant_data = room_plants[i];
        var new_plant = noone;

        if (variable_struct_exists(plant_data, "object_type") && plant_data.object_type == "tomato_plant") {
            new_plant = instance_create_layer(plant_data.x, plant_data.y, "World", obj_tomato_plant);
        } else {
            new_plant = instance_create_layer(plant_data.x, plant_data.y, "World", obj_universal_plant);
            new_plant.plant_type = plant_data.plant_type;
        }

        new_plant.growth_stage = plant_data.growth_stage;
        new_plant.max_growth_stage = plant_data.max_growth_stage;
        new_plant.planted_day = plant_data.planted_day;
        new_plant.can_harvest = plant_data.can_harvest;
        new_plant.sprite_index = plant_data.sprite_index;
        new_plant.image_index = plant_data.image_index;
        new_plant.last_growth_check_day = plant_data.last_growth_check_day;
        new_plant.is_loaded_from_save = true;  // IMPORTANTE: mantiene stato
    }
}

// Funzioni per compatibilità con codice esistente
function save_room1_objects() {
    save_room_objects(Room1);
    // Mantieni anche la vecchia variabile per compatibilità
    global.room1_plants = variable_global_get("room_" + string(Room1) + "_plants");
}

function load_room1_objects() {
    load_room_objects(Room1);
}