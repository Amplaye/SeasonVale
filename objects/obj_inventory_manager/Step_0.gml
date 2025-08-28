// ===================================================================
// 🎒 INVENTORY INPUT - GESTIONE CONTROLLI
// ===================================================================

// ===== TOGGLE INVENTARIO =====
// Tasto I per aprire/chiudere inventario
if (keyboard_check_pressed(ord("I"))) {
    global.inventory_visible = !global.inventory_visible;
    show_debug_message("🎒 Inventario " + (global.inventory_visible ? "aperto" : "chiuso"));
}

// ===== UI FISSA - POSIZIONAMENTO IDENTICO TOOLBAR =====
// STESSA LOGICA DELLA TOOLBAR per seguire la camera
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);

var screen_w = 480;
var screen_h = 270;
var scaled_slot_width = sprite_get_width(slot) * global.slot_scale * global.inventory_scale;
var scaled_slot_height = sprite_get_height(slot) * global.slot_scale * global.inventory_scale;

// Calcola dimensioni totali inventario
var total_width = (global.inventory_cols * scaled_slot_width) + ((global.inventory_cols - 1) * global.inventory_gap_x);
var total_height = (global.inventory_rows * scaled_slot_height) + ((global.inventory_rows - 1) * global.inventory_gap_y);

// Posiziona centrato nella camera (ESATTAMENTE come toolbar)
var inventory_start_x = cam_x + (screen_w - total_width) / 2;
var inventory_start_y = cam_y + (screen_h - total_height) / 2;

x = inventory_start_x;
y = inventory_start_y;

// ===== GESTIONE DRAG & DROP INVENTORY =====
if (global.inventory_visible) {
    // Controlla click su slot per drag o selezione
    for (var i = 0; i < global.inventory_total_slots; i++) {
        var slot_pos = get_slot_position(i);
        var slot_x = slot_pos[0];
        var slot_y = slot_pos[1];
        
        var scaled_slot_width = sprite_get_width(slot) * global.slot_scale * global.inventory_scale;
        var scaled_slot_height = sprite_get_height(slot) * global.slot_scale * global.inventory_scale;
        
        var mouse_over = point_in_rectangle(mouse_x, mouse_y, slot_x, slot_y, slot_x + scaled_slot_width, slot_y + scaled_slot_height);
        
        if (mouse_over && is_slot_unlocked(i)) {
            var slot_data = get_slot_data(i);
            var item_sprite = slot_data[0];
            var quantity = slot_data[1];
            
            // DRAG START & SELEZIONE - stessa logica toolbar (click sinistro)
            if (mouse_check_button_pressed(mb_left) && item_sprite != noone) {
                global.toolbar_dragging = true;
                global.toolbar_drag_from_slot = i;
                global.toolbar_drag_item = item_sprite;
                global.toolbar_drag_start_x = mouse_x;
                global.toolbar_drag_start_y = mouse_y;
                // Se prima riga, seleziona anche il tool
                if (i < 10) {
                    global.selected_tool = i;
                }
                show_debug_message("🖱️ DRAG INIZIATO: slot " + string(i) + " sprite " + sprite_get_name(item_sprite));
                break;
            }
            // SELEZIONE senza item - solo per prima riga (toolbar)
            else if (mouse_check_button_pressed(mb_left) && !global.toolbar_dragging && i < 10) {
                global.selected_tool = i;
                show_debug_message("🔧 Tool selezionato dall'inventario: slot " + string(i));
                break;
            }
        }
        // Slot bloccato
        else if (mouse_over && !is_slot_unlocked(i) && mouse_check_button_pressed(mb_left)) {
            show_debug_message("🔒 Slot bloccato! Espandi l'inventario per usarlo.");
            break;
        }
    }
    
    // DRAG DROP - gestione rilascio
    if (global.toolbar_dragging && mouse_check_button_released(mb_left)) {
        show_debug_message("🖱️ Drop nell'inventory - controllo slot target");
        
        var drop_slot = -1;
        
        // Trova slot di drop nell'inventory
        for (var i = 0; i < global.inventory_total_slots; i++) {
            if (!is_slot_unlocked(i)) continue;
            
            var slot_pos = get_slot_position(i);
            var slot_x = slot_pos[0];
            var slot_y = slot_pos[1];
            
            var scaled_slot_width = sprite_get_width(slot) * global.slot_scale * global.inventory_scale;
            var scaled_slot_height = sprite_get_height(slot) * global.slot_scale * global.inventory_scale;
            
            if (point_in_rectangle(mouse_x, mouse_y, slot_x, slot_y, slot_x + scaled_slot_width, slot_y + scaled_slot_height)) {
                drop_slot = i;
                break;
            }
        }
        
        if (drop_slot >= 0 && drop_slot != global.toolbar_drag_from_slot) {
            show_debug_message("🔄 Swap tra slot " + string(global.toolbar_drag_from_slot) + " e " + string(drop_slot));
            
            // Gestisce swap tra qualsiasi combinazione di slot inventory/toolbar
            var source_data = get_slot_data(global.toolbar_drag_from_slot);
            var target_data = get_slot_data(drop_slot);
            
            set_slot_data(drop_slot, source_data[0], source_data[1]);
            set_slot_data(global.toolbar_drag_from_slot, target_data[0], target_data[1]);
        }
        
        // Reset drag state
        global.toolbar_dragging = false;
        global.toolbar_drag_from_slot = -1;
        global.toolbar_drag_item = noone;
    }
}