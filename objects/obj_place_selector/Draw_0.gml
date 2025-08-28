// ===================================================================
// 🎯 PLACE SELECTOR - DISEGNA ENTRAMBI POINTER E SELECTOR
// ===================================================================

// Per tool con selector (axe, hoe, pickaxe): disegna prima pointer normale poi selector sopra
if (global.selected_tool >= 0 && global.selected_tool < array_length(global.tool_sprites)) {
    var selected_tool_sprite = global.tool_sprites[global.selected_tool];
    if (selected_tool_sprite == axe || selected_tool_sprite == hoe || selected_tool_sprite == pickaxe) {
        // Disegna pointer normale al mouse
        draw_sprite_ext(pointer, 0, mouse_x, mouse_y, 0.3, 0.3, 0, c_white, 1.0);
        
        // Disegna selector alla griglia (sprite_index è già impostato a place_selector)
        draw_self();
    } else {
        // Solo pointer normale (sprite_index è già impostato a pointer)
        draw_self();
    }
} else {
    // Solo pointer normale (sprite_index è già impostato a pointer)  
    draw_self();
}