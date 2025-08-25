// ===================================================================
// 📦 TOOLBAR ITEM MANAGER - AUTO-POSITIONING SYSTEM
// ===================================================================
// Questo oggetto gestisce automaticamente il posizionamento degli items
// nella toolbar. Cerca tutti gli items nella room e li posiziona 
// automaticamente nel centro degli slot più vicini.

depth = -1500; // Sopra alla toolbar

// ===== CONFIGURAZIONE =====
auto_positioning_enabled = true;
check_interval = 30; // Controlla ogni 30 frames (0.5 secondi)
check_timer = 0;

// Lista degli items che vengono gestiti automaticamente
managed_items = [];

// Funzione helper per aggiungere item alla toolbar
function item_manager_set_toolbar_item(slot_number, item_sprite) {
    var slot_index = slot_number - 1; // Slot 1-10 -> Index 0-9
    if (slot_index >= 0 && slot_index < array_length(global.tool_sprites)) {
        global.tool_sprites[slot_index] = item_sprite;
        if (item_sprite != noone) {
            show_debug_message("📦 Item aggiunto: sprite_" + string(item_sprite) + " -> Slot #" + string(slot_number));
        }
    }
}

function toolbar_auto_position_items() {
    if (!auto_positioning_enabled) return;
    
    // Trova tutti gli asset grafici nella room (i tuoi items)
    var items_found = 0;
    
    // Resetta la lista
    managed_items = [];
    
    // Cerca items nel layer "items"
    var layer_id = layer_get_id("items");
    if (layer_id != -1) {
        var assets = layer_get_all_elements(layer_id);
        
        for (var i = 0; i < array_length(assets); i++) {
            var asset = assets[i];
            
            if (layer_get_element_type(asset) == layerelementtype_sprite) {
                var sprite_asset = layer_sprite_get_sprite(asset);
                
                var asset_info = {
                    id: asset,
                    original_x: layer_sprite_get_x(asset),
                    original_y: layer_sprite_get_y(asset),
                    sprite: sprite_asset,
                    assigned_slot: -1
                };
                
                // Trova il slot più vicino
                var closest_slot = find_closest_toolbar_slot(asset_info.original_x, asset_info.original_y);
                if (closest_slot != -1) {
                    asset_info.assigned_slot = closest_slot;
                    var slot_center = item_manager_get_slot_center(closest_slot + 1);
                    
                    // Muovi l'item al centro dello slot
                    layer_sprite_x(asset, slot_center.x);
                    layer_sprite_y(asset, slot_center.y);
                    
                    // Aggiorna il sistema toolbar
                    item_manager_set_toolbar_item(closest_slot + 1, sprite_asset);
                    
                    items_found++;
                    if (sprite_asset != noone) {
                        show_debug_message("📦 Auto-posizionato: sprite_" + string(sprite_asset) + " -> Slot #" + string(closest_slot + 1));
                    }
                }
                
                array_push(managed_items, asset_info);
            }
        }
    }
    
    if (items_found > 0) {
        show_debug_message("✅ Auto-posizionamento completato: " + string(items_found) + " items");
    }
}

// Funzione helper per calcolare il centro di uno slot
function item_manager_get_slot_center(slot_number) {
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    
    var screen_w = 480;
    var screen_h = 270;
    
    var slot_width = sprite_get_width(tool_slot);
    var total_width = (global.toolbar_slots_count * slot_width) + ((global.toolbar_slots_count - 1) * global.toolbar_gap);
    
    var toolbar_start_x = cam_x + (screen_w - total_width) / 2;
    var toolbar_y = cam_y + screen_h - global.toolbar_distance_from_bottom;
    
    var slot_index = slot_number - 1;
    var slot_x = toolbar_start_x + (slot_index * (slot_width + global.toolbar_gap));
    var center_x = slot_x + (slot_width / 2);
    var center_y = toolbar_y + (sprite_get_height(tool_slot) / 2);
    
    return {x: center_x, y: center_y};
}

function find_closest_toolbar_slot(item_x, item_y) {
    var closest_slot = -1;
    var min_distance = 999999;
    
    for (var i = 1; i <= global.toolbar_slots_count; i++) {
        var slot_center = item_manager_get_slot_center(i);
        var distance = point_distance(item_x, item_y, slot_center.x, slot_center.y);
        
        if (distance < min_distance) {
            min_distance = distance;
            closest_slot = i - 1; // Converti a index 0-based
        }
    }
    
    return closest_slot;
}

// Esegui auto-posizionamento iniziale
toolbar_auto_position_items();