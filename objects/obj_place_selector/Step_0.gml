// ===================================================================
// 🎯 PLACE SELECTOR - MOVIMENTO E LOGICA GRIGLIA
// ===================================================================

// Visibile solo quando il menu principale NON è aperto
visible = !(instance_exists(obj_main_menu) && obj_main_menu.visible);

// Cambia sprite in base al tool selezionato
var show_selector = false;
if (global.selected_tool >= 0 && global.selected_tool < array_length(global.tool_sprites)) {
    var selected_tool_sprite = global.tool_sprites[global.selected_tool];
    if (selected_tool_sprite == spr_axe || selected_tool_sprite == spr_hoe || selected_tool_sprite == spr_pickaxe) {
        show_selector = true;
        sprite_index = spr_place_selector;
        image_xscale = 0.5;
        image_yscale = 0.5;
    } else {
        show_selector = false;
        sprite_index = spr_pointer;
        image_xscale = 0.3;
        image_yscale = 0.3;
    }
} else {
    show_selector = false;
    sprite_index = spr_pointer;
    image_xscale = 0.3;
    image_yscale = 0.3;
}

// Posizionamento del puntatore
if (show_selector) {
    // Converti coordinate mouse da view a mondo
    var cam = camera_get_active();
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var world_mouse_x = mouse_x + view_x;
    var world_mouse_y = mouse_y + view_y;
    
    // SNAP ALLA GRIGLIA: posiziona sul tile più vicino
    var tile_size = 16;
    var grid_x = floor(world_mouse_x / tile_size) * tile_size;
    var grid_y = floor(world_mouse_y / tile_size) * tile_size;
    x = grid_x;
    y = grid_y;
    
    // Effetto pulse per feedback visivo
    var pulse = sin(current_time * 0.01) * 0.2;
    image_alpha = 0.7 + pulse;
} else {
    // Converti coordinate mouse da view a mondo anche per pointer normale
    var cam = camera_get_active();
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var world_mouse_x = mouse_x + view_x;
    var world_mouse_y = mouse_y + view_y;
    x = world_mouse_x;
    y = world_mouse_y;
    image_alpha = 1.0;
}

// Gestisci cursor solo quando il place_selector è visibile (fuori dal menu)
if (visible) {
    window_set_cursor(cr_none);
    if (cursor_sprite != -1) cursor_sprite = -1;
} else if (instance_exists(obj_main_menu) && obj_main_menu.visible) {
    // Quando il menu è aperto, mostra cursor normale
    window_set_cursor(cr_default);
}