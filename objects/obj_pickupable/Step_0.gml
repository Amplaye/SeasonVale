// ===================================================================
// 🧲 SISTEMA RACCOLTA MAGNETICA - LOGICA PRINCIPALE
// ===================================================================

// Se popup attivo, blocca tutto il sistema di raccolta
if (variable_global_exists("popup_active") && global.popup_active) {
    // Il sistema di raccolta è bloccato
    exit;
}

// Riduci cooldown
if (global.pickup_cooldown > 0) {
    global.pickup_cooldown--;
}

// Trova il player
var player_instance = instance_find(global.player_obj, 0);
if (player_instance == noone) exit; // Nessun player trovato

var player_x = player_instance.x;
var player_y = player_instance.y;

// Ottieni il layer appropriato - cerca in ordine di priorità
var pickup_layer = -1;
var layer_elements = [];

// Prima prova con "pickupable"
if (layer_exists("pickupable")) {
    pickup_layer = layer_get_id("pickupable");
    layer_elements = layer_get_all_elements(pickup_layer);
}

// Se non trovato o vuoto, prova "Instances"
if (array_length(layer_elements) == 0 && layer_exists("Instances")) {
    pickup_layer = layer_get_id("Instances");
    var instances_elements = layer_get_all_elements(pickup_layer);
    // Aggiungi elementi al nostro array
    for (var k = 0; k < array_length(instances_elements); k++) {
        array_push(layer_elements, instances_elements[k]);
    }
}

// Se ancora vuoto, prova "World"
if (array_length(layer_elements) == 0 && layer_exists("World")) {
    pickup_layer = layer_get_id("World");
    var world_elements = layer_get_all_elements(pickup_layer);
    // Aggiungi elementi al nostro array
    for (var k = 0; k < array_length(world_elements); k++) {
        array_push(layer_elements, world_elements[k]);
    }
}

// Se nessun layer trovato, esci
if (pickup_layer == -1) {
    exit;
}

// Sistema semplificato - solo sprite nel layer

// Poi scorri tutti gli elementi del layer
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
                
            }
            
            // ===== RACCOLTA =====
            else if (distance <= global.pickup_range && global.pickup_cooldown <= 0) {
                // Prova a raccogliere l'oggetto (quantità gestita internamente)
                var was_added = pickup_item(element_sprite, element);
                
                // Rimuovi lo sprite dal layer SOLO se è stato aggiunto all'inventario
                if (was_added) {
                    layer_sprite_destroy(element);
                    
                } else {
                    // Se non aggiunto, l'oggetto rimbalza (già gestito in pickup_item)
                }
                
                // Imposta cooldown in ogni caso per evitare spam
                global.pickup_cooldown = global.pickup_cooldown_max;
                
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
    
    if (!added && global.pickup_debug) {
        
        // EFFETTO RIMBALZANTE: Sposta l'oggetto lontano dal player
        var element_x = layer_sprite_get_x(element_id);
        var element_y = layer_sprite_get_y(element_id);
        var player_instance = instance_find(global.player_obj, 0);
        
        if (player_instance != noone) {
            // Calcola direzione opposta al player
            var bounce_dir = point_direction(player_instance.x, player_instance.y, element_x, element_y);
            var bounce_distance = 15; // Distanza rimbalzo
            
            var new_x = element_x + lengthdir_x(bounce_distance, bounce_dir);
            var new_y = element_y + lengthdir_y(bounce_distance, bounce_dir);
            
            // Sposta l'oggetto
            layer_sprite_x(element_id, new_x);
            layer_sprite_y(element_id, new_y);
            
        }
    }
    
    // Ritorna se è stato aggiunto o no
    return added;
}