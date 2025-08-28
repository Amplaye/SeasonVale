// ===================================================================
// TOOLBAR DRAG VISUAL FEEDBACK - DRAW GUI LAYER
// ===================================================================

// DEBUG: Rimosso per evitare spam nei log

// Disegna l'item che viene trascinato sopra tutto usando coordinate GUI
if (global.toolbar_dragging && global.toolbar_drag_from_slot >= 0) {
    // Ottieni lo sprite direttamente dall'array usando l'indice del slot
    var slot_index = global.toolbar_drag_from_slot;
    
    if (slot_index >= 0 && slot_index < array_length(global.tool_sprites)) {
        var sprite_to_draw = global.tool_sprites[slot_index];
        
        if (sprite_to_draw != noone) {
            // Ottieni scala dal scaling manager e aumentala per visibilità
            var drag_scale = 1.5; // Default
            if (variable_global_exists("sprite_scales")) {
                var sprite_name = sprite_get_name(sprite_to_draw);
                if (variable_struct_exists(global.sprite_scales, sprite_name)) {
                    var scale_data = global.sprite_scales[$ sprite_name];
                    drag_scale = scale_data.scale_x * 4.0;
                }
            }
            
            // Converti mouse da coordinate mondo a coordinate GUI
            var gui_mouse_x = device_mouse_x_to_gui(0);
            var gui_mouse_y = device_mouse_y_to_gui(0);
            
            // Ottieni dimensioni sprite per centratura
            var sprite_w = sprite_get_width(sprite_to_draw);
            var sprite_h = sprite_get_height(sprite_to_draw);
            
            // Disegna l'item centrato sul cursore del mouse
            draw_sprite_ext(sprite_to_draw, 0, 
                           gui_mouse_x - sprite_w/2, 
                           gui_mouse_y - sprite_h/2, 
                           drag_scale, drag_scale, 0, c_white, 0.8);
        }
    }
}

// ===================================================================
// POPUP INVENTARIO PIENO - ORA GESTITO DA obj_popup_error
// ===================================================================
// Il popup è ora gestito dall'oggetto obj_popup_error nel room