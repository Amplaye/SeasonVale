if (variable_global_exists("toolbar_dragging") && global.toolbar_dragging) {
    // Detection più diretta usando bounding box
    if (point_in_rectangle(mouse_x, mouse_y, x, y, x + sprite_width, y + sprite_height)) {
        if (!hovered) {
            hovered = true;
            image_index = 1;
            show_debug_message("🗑️ Trash chest hover ON");
        }
        
        if (mouse_check_button_released(mb_left)) {
            if (variable_global_exists("toolbar_drag_from_slot") && global.toolbar_drag_from_slot >= 0) {
                var slot_index = global.toolbar_drag_from_slot;
                show_debug_message("🗑️ RICEVUTO DROP - Slot: " + string(slot_index));
                
                // Gestisce tutti gli slot (toolbar e inventory)
                if (slot_index < 10) {
                    // Slot toolbar (0-9)
                    if (slot_index >= 0 && slot_index < array_length(global.tool_sprites)) {
                        var item_sprite = global.tool_sprites[slot_index];
                        if (item_sprite != noone) {
                            show_debug_message("🗑️ Eliminando oggetto toolbar slot " + string(slot_index) + ": " + sprite_get_name(item_sprite));
                            global.tool_sprites[slot_index] = noone;
                            global.tool_quantities[slot_index] = 0;
                            
                            if (global.selected_tool == slot_index) {
                                global.selected_tool = -1;
                            }
                        }
                    }
                } else {
                    // Slot inventory estesi (10+)
                    var extended_index = slot_index - 10;
                    if (extended_index >= 0 && extended_index < array_length(global.inventory_extended_sprites)) {
                        var item_sprite = global.inventory_extended_sprites[extended_index];
                        if (item_sprite != noone) {
                            show_debug_message("🗑️ Eliminando oggetto inventory slot " + string(slot_index) + ": " + sprite_get_name(item_sprite));
                            global.inventory_extended_sprites[extended_index] = noone;
                            global.inventory_extended_quantities[extended_index] = 0;
                        }
                    }
                }
            }
            
            image_index = 2;
            
            global.toolbar_dragging = false;
            global.toolbar_drag_from_slot = -1;
            
            alarm[0] = 30;
        }
    } else {
        if (hovered) {
            hovered = false;
            image_index = 0;
            show_debug_message("🗑️ Trash chest hover OFF");
        }
    }
} else {
    if (hovered) {
        hovered = false;
        image_index = 0;
    }
}