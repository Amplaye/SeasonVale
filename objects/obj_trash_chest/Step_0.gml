if (variable_global_exists("toolbar_dragging") && global.toolbar_dragging) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        if (!hovered) {
            hovered = true;
            image_index = 1;
            show_debug_message("🗑️ Trash chest hover ON");
        }
        
        if (mouse_check_button_released(mb_left)) {
            if (variable_global_exists("toolbar_drag_from_slot") && global.toolbar_drag_from_slot >= 0) {
                var slot_index = global.toolbar_drag_from_slot;
                if (slot_index >= 0 && slot_index < array_length(global.tool_sprites)) {
                    show_debug_message("🗑️ Eliminando oggetto slot " + string(slot_index) + ": " + sprite_get_name(global.tool_sprites[slot_index]));
                    
                    global.tool_sprites[slot_index] = noone;
                    global.tool_quantities[slot_index] = 0;
                    
                    if (global.selected_tool == slot_index) {
                        global.selected_tool = -1;
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