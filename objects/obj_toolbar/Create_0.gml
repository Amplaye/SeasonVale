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
global.toolbar_gap = 2;
global.toolbar_distance_from_bottom = 50;
global.toolbar_debug_enabled = false;

// ===== STORAGE ITEMS =====
// Inizializzazione solo una volta
if (!variable_global_exists("tool_sprites")) {
    // CONTROLLO SICUREZZA: assegnazione diretta sprite per evitare GM1063
    var axe_sprite = axe;
    var mining_sprite = pickaxe;
    var fishing_sprite = fishing_rod;
    var zappa_sprite = hoe;
    
    global.tool_sprites = [axe_sprite, mining_sprite, fishing_sprite, zappa_sprite, noone, noone, noone, noone, noone, noone];
    global.tool_quantities = [1, 1, 1, 1, 0, 0, 0, 0, 0, 0];
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
    
    // Prima cerca se l'item esiste già per fare stacking
    for (var i = 0; i < array_length(global.tool_sprites); i++) {
        if (global.tool_sprites[i] == item_sprite && global.tool_quantities[i] > 0) {
            global.tool_quantities[i] += quantity;
            show_debug_message("📦 Stack aumentato: " + sprite_get_name(item_sprite) + " x" + string(global.tool_quantities[i]));
            return true;
        }
    }
    
    // Se non esiste, cerca primo slot vuoto
    for (var i = 0; i < array_length(global.tool_sprites); i++) {
        if (global.tool_sprites[i] == noone || global.tool_quantities[i] == 0) {
            global.tool_sprites[i] = item_sprite;
            global.tool_quantities[i] = quantity;
            show_debug_message("📦 Nuovo item: " + sprite_get_name(item_sprite) + " x" + string(quantity) + " -> Slot #" + string(i + 1));
            return true;
        }
    }
    
    show_debug_message("⚠️ Toolbar piena! Item non aggiunto: " + sprite_get_name(item_sprite));
    return false;
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