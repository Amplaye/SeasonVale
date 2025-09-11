// ===================================================================
// 🎯 PLACE SELECTOR - DISEGNA ENTRAMBI POINTER E SELECTOR
// ===================================================================

// Per tool con selector (axe, hoe, pickaxe): disegna prima pointer normale poi selector sopra
if (global.selected_tool >= 0 && global.selected_tool < array_length(global.tool_sprites)) {
    var selected_tool_sprite = global.tool_sprites[global.selected_tool];
    if (selected_tool_sprite == spr_axe || selected_tool_sprite == spr_hoe || selected_tool_sprite == spr_pickaxe) {
        // Disegna pointer normale al mouse
        draw_sprite_ext(spr_pointer, 0, mouse_x, mouse_y, 0.3, 0.3, 0, c_white, 1.0);
        
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