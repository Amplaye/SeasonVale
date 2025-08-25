// ===================================================================
// 🧲 SISTEMA RACCOLTA MAGNETICA - LOGICA PRINCIPALE
// ===================================================================

// Riduci cooldown
if (global.pickup_cooldown > 0) {
    global.pickup_cooldown--;
}

// Trova il player
var player_instance = instance_find(global.player_obj, 0);
if (player_instance == noone) exit; // Nessun player trovato

var player_x = player_instance.x;
var player_y = player_instance.y;

// Ottieni il layer pickupable
var pickup_layer = layer_get_id(global.pickup_layer_name);
if (pickup_layer == -1) {
    if (global.pickup_debug) {
        show_debug_message("⚠️ Layer 'pickupable' non trovato!");
    }
    exit;
}

// Ottieni tutti gli elementi del layer
var layer_elements = layer_get_all_elements(pickup_layer);

// Scorri tutti gli elementi del layer
for (var i = 0; i < array_length(layer_elements); i++) {
    var element = layer_elements[i];
    
    // Controlla se è un asset (sprite)
    if (layer_get_element_type(element) == layerelementtype_sprite) {
        var element_sprite = layer_sprite_get_sprite(element);
        var element_x = layer_sprite_get_x(element);
        var element_y = layer_sprite_get_y(element);
        
        // Controlla se questo sprite è nella lista dei raccoglibili
        var is_pickupable = false;
        for (var j = 0; j < array_length(global.pickupable_sprites); j++) {
            if (element_sprite == global.pickupable_sprites[j]) {
                is_pickupable = true;
                break;
            }
        }
        
        if (is_pickupable) {
            var distance = point_distance(player_x, player_y, element_x, element_y);
            
            // ===== EFFETTO MAGNETE =====
            if (global.magnet_enabled && distance <= global.magnet_range && distance > global.pickup_range) {
                // Calcola direzione verso il player
                var dir = point_direction(element_x, element_y, player_x, player_y);
                var move_x = lengthdir_x(global.magnet_speed, dir);
                var move_y = lengthdir_y(global.magnet_speed, dir);
                
                // Muovi lo sprite verso il player
                layer_sprite_x(element, element_x + move_x);
                layer_sprite_y(element, element_y + move_y);
                
                if (global.pickup_debug) {
                    show_debug_message("🧲 Attrazione: " + sprite_get_name(element_sprite) + 
                                     " dist:" + string(round(distance)));
                }
            }
            
            // ===== RACCOLTA =====
            else if (distance <= global.pickup_range && global.pickup_cooldown <= 0) {
                // Raccogli l'oggetto
                pickup_item(element_sprite, element);
                
                // Rimuovi lo sprite dal layer
                layer_sprite_destroy(element);
                
                // Imposta cooldown
                global.pickup_cooldown = global.pickup_cooldown_max;
                
                if (global.pickup_debug) {
                    show_debug_message("📦 Raccolto: " + sprite_get_name(element_sprite));
                }
                
                // Esci dal loop per evitare problemi con array modificato
                break;
            }
        }
    }
}

// ===== FUNZIONE RACCOLTA =====
function pickup_item(sprite_id, element_id) {
    // Trova l'istanza della toolbar
    var toolbar_instance = instance_find(obj_toolbar, 0);
    var added = false;
    
    if (toolbar_instance != noone) {
        // Chiama la funzione toolbar_add_item dall'istanza della toolbar
        added = toolbar_instance.toolbar_add_item(sprite_id, 1);
    }
    
    if (added && global.pickup_debug) {
        show_debug_message("✅ Item aggiunto alla toolbar: " + sprite_get_name(sprite_id));
    } else if (!added && global.pickup_debug) {
        show_debug_message("❌ Toolbar piena o non trovata! Item perso: " + sprite_get_name(sprite_id));
    }
    
    // Effetti visivi/sonori opzionali
    if (global.pickup_effects) {
        // Qui puoi aggiungere effetti particellari, suoni, etc.
        // effect_create_above(ef_ring, element_x, element_y, 0, c_yellow);
    }
}