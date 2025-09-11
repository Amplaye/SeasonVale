// ===================================================================
// 📋 TOOLBAR SYSTEM - CONFIGURAZIONE CENTRALE
// ===================================================================
// Gestisce la toolbar farming con 10 slot per items
// Controlli: Tasti 1,2,3,4,5,6,7,8,9,0 per selezione
// Debug: Ctrl+D = mostra/nascondi posizioni slot
// Auto-posizionamento: Items si centrano automaticamente negli slot

depth = -1000;

// ===== DRAG & DROP SISTEMA =====
global.toolbar_dragging = false;
global.toolbar_drag_from_slot = -1;
global.toolbar_drag_item = noone;
global.toolbar_drag_start_x = 0;
global.toolbar_drag_start_y = 0;

// ===== IMPOSTAZIONI TOOLBAR =====
global.toolbar_slots_count = 10;
global.toolbar_gap = 1;
global.toolbar_distance_from_bottom = 30;
global.toolbar_debug_enabled = false;

// ===== POSIZIONAMENTO AUTOMATICO =====
// Calcola posizione centrata
var cam = view_camera[0];
var screen_w = 480;
var slot_scale = 0.5;
var scaled_slot_width = sprite_get_width(spr_slot) * slot_scale;
var total_width = (global.toolbar_slots_count * scaled_slot_width) + ((global.toolbar_slots_count - 1) * global.toolbar_gap);
var toolbar_start_x = (screen_w - total_width) / 2;

x = toolbar_start_x;
y = 270 - global.toolbar_distance_from_bottom;

// ===== STORAGE ITEMS =====
// Inizializzazione solo una volta
if (!variable_global_exists("tool_sprites")) {
    // CONTROLLO SICUREZZA: assegnazione diretta sprite per evitare GM1063
    var axe_sprite = spr_axe;
    var mining_sprite = spr_pickaxe;
    var fishing_sprite = spr_fishing_rod;
    var zappa_sprite = spr_hoe;
    var tomato_seed_sprite = spr_tomato;  // Seme di pomodoro
    var carrot_seed_sprite = spr_carrot;  // Seme di carota
    
    global.tool_sprites = [axe_sprite, mining_sprite, zappa_sprite, fishing_sprite, tomato_seed_sprite, carrot_seed_sprite, noone, noone, noone, noone];
    global.tool_quantities = [1, 1, 1, 1, 10, 5, 0, 0, 0, 0];  // 10 semi pomodoro, 5 semi carota
    global.selected_tool = 0;
    
    show_debug_message("🔧 Toolbar inizializzata:");
    show_debug_message("  axe: " + string(axe_sprite) + " (exists: " + string(sprite_exists(axe_sprite)) + ")");
    show_debug_message("  mining: " + string(mining_sprite) + " (exists: " + string(sprite_exists(mining_sprite)) + ")");
    show_debug_message("  fishing: " + string(fishing_sprite) + " (exists: " + string(sprite_exists(fishing_sprite)) + ")");
    show_debug_message("  zappa: " + string(zappa_sprite) + " (exists: " + string(sprite_exists(zappa_sprite)) + ")");
}

// ===== FUNZIONI PRINCIPALI =====

// Aggiunge un item a uno slot specifico
function toolbar_set_item(slot_number, item_sprite) {
    var slot_index = slot_number - 1; // Slot 1-10 -> Index 0-9
    if (slot_index >= 0 && slot_index < array_length(global.tool_sprites)) {
        global.tool_sprites[slot_index] = item_sprite;
        global.tool_quantities[slot_index] = (item_sprite != noone) ? 1 : 0;
        if (item_sprite != noone) {
            show_debug_message("📦 Item aggiunto: sprite_" + string(item_sprite) + " -> Slot #" + string(slot_number));
        }
    }
}

// Aggiunge un item alla toolbar con sistema di stacking
function toolbar_add_item(item_sprite, quantity = 1) {
    // CONTROLLO SICUREZZA: deve essere uno sprite valido
    if (!sprite_exists(item_sprite)) {
        show_debug_message("⚠️ ERRORE toolbar_add_item: sprite non valido = " + string(item_sprite));
        return false;
    }
    
    var max_stack_size = 999;
    var remaining_quantity = quantity;
    
    // Prima cerca se l'item esiste già per fare stacking
    for (var i = 0; i < array_length(global.tool_sprites); i++) {
        if (global.tool_sprites[i] == item_sprite && global.tool_quantities[i] > 0) {
            var current_quantity = global.tool_quantities[i];
            var space_available = max_stack_size - current_quantity;
            
            if (space_available > 0) {
                var quantity_to_add = min(remaining_quantity, space_available);
                global.tool_quantities[i] += quantity_to_add;
                remaining_quantity -= quantity_to_add;
                
                show_debug_message("📦 Stack aumentato: " + sprite_get_name(item_sprite) + " x" + string(global.tool_quantities[i]));
                
                if (remaining_quantity <= 0) {
                    return true;
                }
            }
        }
    }
    
    // Se rimane quantità, cerca primi slot vuoti
    while (remaining_quantity > 0) {
        var empty_slot_found = false;
        
        for (var i = 0; i < array_length(global.tool_sprites); i++) {
            if (global.tool_sprites[i] == noone || global.tool_quantities[i] == 0) {
                global.tool_sprites[i] = item_sprite;
                var quantity_to_add = min(remaining_quantity, max_stack_size);
                global.tool_quantities[i] = quantity_to_add;
                remaining_quantity -= quantity_to_add;
                
                show_debug_message("📦 Nuovo item: " + sprite_get_name(item_sprite) + " x" + string(quantity_to_add) + " -> Slot #" + string(i + 1));
                empty_slot_found = true;
                break;
            }
        }
        
        if (!empty_slot_found) {
            if (remaining_quantity > 0) {
                show_debug_message("⚠️ Toolbar piena! Non si possono aggiungere " + string(remaining_quantity) + " x " + sprite_get_name(item_sprite));
                show_toolbar_full_popup(item_sprite, remaining_quantity);
                return false;
            }
            break;
        }
    }
    
    return true;
}

// Ottiene l'item attualmente selezionato
function toolbar_get_current_item() {
    if (global.selected_tool >= 0 && global.selected_tool < array_length(global.tool_sprites)) {
        return global.tool_sprites[global.selected_tool];
    }
    return noone;
}

// Calcola il centro di uno slot specifico
function toolbar_get_slot_center(slot_number) {
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    
    var screen_w = 480;
    var screen_h = 270;
    
    var slot_scale = 0.5;
    var scaled_slot_width = sprite_get_width(spr_slot) * slot_scale;
    var scaled_slot_height = sprite_get_height(spr_slot) * slot_scale;
    var total_width = (global.toolbar_slots_count * scaled_slot_width) + ((global.toolbar_slots_count - 1) * global.toolbar_gap);
    
    var toolbar_start_x = cam_x + (screen_w - total_width) / 2;
    var toolbar_y = cam_y + screen_h - global.toolbar_distance_from_bottom;
    
    var slot_index = slot_number - 1;
    var slot_x = toolbar_start_x + (slot_index * (scaled_slot_width + global.toolbar_gap));
    var center_x = slot_x + (scaled_slot_width / 2);
    var center_y = toolbar_y + (scaled_slot_height / 2);
    
    return {x: center_x, y: center_y};
}

// ===== SISTEMA POPUP INVENTARIO PIENO =====
global.popup_active = false;
global.popup_item_name = "";
global.popup_quantity = 0;

// Mostra popup quando inventario è pieno
function show_toolbar_full_popup(item_sprite, quantity) {
    global.popup_active = true;
    global.popup_item_name = sprite_get_name(item_sprite);
    global.popup_quantity = quantity;
    
    show_debug_message("🚨 Popup mostrato: Inventario pieno per " + string(quantity) + " x " + global.popup_item_name);
}