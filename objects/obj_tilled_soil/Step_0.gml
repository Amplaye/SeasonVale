// Controlla se il player vuole piantare un seme SOLO su questo tile specifico
// Aggiungi cooldown globale per evitare multipli plant nello stesso frame
if (!variable_global_exists("plant_cooldown")) global.plant_cooldown = 0;
if (global.plant_cooldown > 0) global.plant_cooldown--;

// Controlla se il player ha un seme selezionato e vuole piantarlo
var selected_seed_sprite = -1; // Inizializza come sprite asset ID
if (global.selected_tool >= 0 && global.selected_tool < array_length(global.tool_sprites)) {
    var tool_sprite = global.tool_sprites[global.selected_tool];
    if (tool_sprite != noone && is_valid_seed(tool_sprite) && sprite_exists(tool_sprite)) {
        selected_seed_sprite = tool_sprite;
    }
}

if (mouse_check_button_pressed(mb_left) && selected_seed_sprite != -1 && !has_seed && global.plant_cooldown <= 0) {
    // Converti coordinate mouse da view a mondo (senza snap)
    var cam = camera_get_active();
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var world_mouse_x = mouse_x + view_x;
    var world_mouse_y = mouse_y + view_y;
    
    // Calcola distanza precisa dal centro di questo tile
    var distance_from_center = point_distance(x, y, world_mouse_x, world_mouse_y);
    
    // Solo se clicca vicino al centro di QUESTO tile (12 pixel per maggiore tolleranza)
    if (distance_from_center < 12) {
        // Trova il tile più vicino al mouse per assicurarsi che sia proprio questo
        var closest_soil = instance_nearest(world_mouse_x, world_mouse_y, obj_tilled_soil);
        
        // Procedi solo se QUESTO è il tile più vicino al mouse
        if (closest_soil == id) {
            // Controlla se ha semi disponibili
            if (global.tool_quantities[global.selected_tool] > 0) {
                // Verifica che selected_seed_sprite sia uno sprite valido
                if (sprite_exists(selected_seed_sprite)) {
                    plant_seed_universal(selected_seed_sprite);
                    
                    // Consuma il seme
                    global.tool_quantities[global.selected_tool]--;
                    
                    // Imposta cooldown per evitare multiple plants
                    global.plant_cooldown = 10;
                }
            } else {
                if (sprite_exists(selected_seed_sprite)) {
                    show_debug_message("🚫 No " + sprite_get_name(selected_seed_sprite) + " seeds available!");
                } else {
                    show_debug_message("🚫 No seeds available!");
                }
            }
        }
    }
}

// Funzione per piantare il seme usando il sistema universale
function plant_seed_universal(seed_sprite) {
    if (has_seed) return;  // Già piantato qualcosa
    
    // Usa il nuovo sistema per piantare
    var plant_instance = plant_seed_at_position(seed_sprite, x, y);
    
    if (plant_instance != noone) {
        has_seed = true;
        var plant_type = get_plant_type_from_seed(seed_sprite);
        planted_seed_type = plant_type;
        self.plant_instance = plant_instance;
        
        if (plant_type != undefined) {
            show_debug_message("🌱 " + string_upper(string(plant_type)) + " seed planted successfully!");
        }
    } else {
        if (sprite_exists(seed_sprite)) {
            show_debug_message("❌ Failed to plant seed: " + sprite_get_name(seed_sprite));
        } else {
            show_debug_message("❌ Failed to plant seed: invalid sprite");
        }
    }
}