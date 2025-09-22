// ===================================================================
// 🎯 PLACE SELECTOR - DISEGNA SOLO SELECTOR GRIGLIA
// ===================================================================

// Per tool con selector (axe, hoe, pickaxe): disegna solo il selector griglia
if (global.selected_tool >= 0 && global.selected_tool < array_length(global.tool_sprites)) {
    var selected_tool_sprite = global.tool_sprites[global.selected_tool];
    if (selected_tool_sprite == spr_axe || selected_tool_sprite == spr_hoe || selected_tool_sprite == spr_pickaxe) {
        // Disegna solo selector alla griglia (pointer è gestito da cursor_manager)
        draw_self();
    }
}