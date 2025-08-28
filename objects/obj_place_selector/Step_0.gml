// ===================================================================
// 🎯 PLACE SELECTOR - MOVIMENTO E LOGICA GRIGLIA
// ===================================================================

// Sempre visibile come puntatore principale
visible = true;

// Cambia sprite in base al tool selezionato
var show_selector = false;
if (global.selected_tool >= 0 && global.selected_tool < array_length(global.tool_sprites)) {
    var selected_tool_sprite = global.tool_sprites[global.selected_tool];
    if (selected_tool_sprite == axe || selected_tool_sprite == hoe || selected_tool_sprite == pickaxe) {
        show_selector = true;
        sprite_index = place_selector;
        image_xscale = 0.5;
        image_yscale = 0.5;
    } else {
        show_selector = false;
        sprite_index = pointer;
        image_xscale = 0.3;
        image_yscale = 0.3;
    }
} else {
    show_selector = false;
    sprite_index = pointer;
    image_xscale = 0.3;
    image_yscale = 0.3;
}

// Posizionamento del puntatore
if (show_selector) {
    // SNAP ALLA GRIGLIA: posiziona sul tile più vicino
    var tile_size = 16;
    var grid_x = floor(mouse_x / tile_size) * tile_size;
    var grid_y = floor(mouse_y / tile_size) * tile_size;
    x = grid_x;
    y = grid_y;
    
    // Effetto pulse per feedback visivo
    var pulse = sin(current_time * 0.01) * 0.2;
    image_alpha = 0.7 + pulse;
} else {
    // Segui il mouse normalmente
    x = mouse_x;
    y = mouse_y;
    image_alpha = 1.0;
}

// Forza nascondere cursor di sistema sempre
window_set_cursor(cr_none);
if (cursor_sprite != -1) cursor_sprite = -1;