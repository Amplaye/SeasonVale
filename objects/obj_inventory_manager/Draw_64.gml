// ===================================================================
// 🖱️ DRAG ITEM RENDERING - STESSA LOGICA TOOLBAR
// ===================================================================

// Disegna item trascinato (sia da inventory che da toolbar)
if (global.toolbar_dragging && global.toolbar_drag_from_slot >= 0) {
    
    var slot_index = global.toolbar_drag_from_slot;
    var slot_data = get_slot_data(slot_index);
    var item_sprite = slot_data[0];
    
    if (item_sprite != noone && sprite_exists(item_sprite)) {
        
        // STESSA LOGICA SCALING DELLA TOOLBAR
        var drag_scale = 1.5; // Default
        if (variable_global_exists("sprite_scales")) {
            var sprite_name = sprite_get_name(item_sprite);
            if (variable_struct_exists(global.sprite_scales, sprite_name)) {
                var scale_data = global.sprite_scales[$ sprite_name];
                drag_scale = scale_data.scale_x * 4.0;
            }
        }
        
        var drag_width = sprite_get_width(item_sprite) * drag_scale;
        var drag_height = sprite_get_height(item_sprite) * drag_scale;
        
        // STESSA CENTRATURA DELLA TOOLBAR
        draw_sprite_ext(item_sprite, 0, 
                       mouse_x - (drag_width / 2), 
                       mouse_y - (drag_height / 2), 
                       drag_scale, drag_scale, 0, c_white, 0.8);
    }
}