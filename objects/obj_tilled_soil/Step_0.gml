// Controlla se il player vuole piantare un seme SOLO su questo tile specifico
// Aggiungi cooldown globale per evitare multipli plant nello stesso frame
if (!variable_global_exists("plant_cooldown")) global.plant_cooldown = 0;
if (global.plant_cooldown > 0) global.plant_cooldown--;

if (mouse_check_button_pressed(mb_left) && global.selected_tool == 4 && !has_seed && global.plant_cooldown <= 0) {
    // Calcola distanza precisa dal centro di questo tile
    var distance_from_center = point_distance(x, y, mouse_x, mouse_y);
    
    // Solo se clicca vicino al centro di QUESTO tile (12 pixel per maggiore tolleranza)
    if (distance_from_center < 12) {
        // Trova il tile più vicino al mouse per assicurarsi che sia proprio questo
        var closest_soil = instance_nearest(mouse_x, mouse_y, obj_tilled_soil);
        
        // Procedi solo se QUESTO è il tile più vicino al mouse
        if (closest_soil == id) {
            // Controlla se ha semi disponibili
            if (global.tool_quantities[4] > 0) {
                plant_seed("tomato");
                
                // Consuma il seme
                global.tool_quantities[4]--;
                
                // Imposta cooldown per evitare multiple plants
                global.plant_cooldown = 10;
                
                // Semi piantati con successo (debug rimosso per pulizia)
            } else {
                show_debug_message("🚫 No tomato seeds available!");
            }
        }
    }
}

// Funzione per piantare il seme
function plant_seed(seed_type) {
    if (has_seed) return;  // Già piantato qualcosa
    
    has_seed = true;
    planted_seed_type = seed_type;
    
    // Crea la pianta corrispondente
    switch(seed_type) {
        case "tomato":
            plant_instance = instance_create_depth(x, y, depth - 1, obj_tomato_plant);
            break;
        // Altri tipi di semi in futuro...
    }
    
    // Semi piantati (debug rimosso per output pulito)
}