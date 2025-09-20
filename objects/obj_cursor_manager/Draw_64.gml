// ===================================================================
// 🖱️ CURSOR RENDERING - DISEGNO CURSOR SOPRA TUTTO
// ===================================================================

// Controlla se il menu principale è aperto (evita interferenze)
var menu_open = false;
if (variable_global_exists("menu_visible")) {
    menu_open = global.menu_visible;
} else if (instance_exists(obj_main_menu)) {
    // Fallback: controlla se il menu esiste ed è visibile
    var menu_obj = instance_find(obj_main_menu, 0);
    if (menu_obj != noone && variable_instance_exists(menu_obj, "visible")) {
        menu_open = menu_obj.visible;
    }
}

// Non disegnare il cursor se il menu è aperto
if (menu_open) {
    exit;
}

// Disegna item trascinato (sia da inventory che da toolbar)
if (global.toolbar_dragging && global.toolbar_drag_from_slot >= 0) {

    var slot_index = global.toolbar_drag_from_slot;

    // Ottieni dati slot usando la funzione dell'inventory manager
    var slot_data = [noone, 0];
    if (instance_exists(obj_inventory_manager)) {
        slot_data = obj_inventory_manager.get_slot_data(slot_index);
    }

    var item_sprite = slot_data[0];

    if (item_sprite != noone && sprite_exists(item_sprite)) {

        // STESSA LOGICA SCALING DELLA TOOLBAR E INVENTORY
        var drag_scale = 1.5; // Default
        if (variable_global_exists("sprite_scales")) {
            var sprite_name = sprite_get_name(item_sprite);
            if (variable_struct_exists(global.sprite_scales, sprite_name)) {
                var scale_data = global.sprite_scales[$ sprite_name];
                drag_scale = scale_data.scale_x * 4.0;
            }
        }

        // Converti mouse da coordinate mondo a coordinate GUI (COME TOOLBAR)
        var gui_mouse_x = device_mouse_x_to_gui(0);
        var gui_mouse_y = device_mouse_y_to_gui(0);

        // Ottieni dimensioni sprite per centratura
        var sprite_w = sprite_get_width(item_sprite);
        var sprite_h = sprite_get_height(item_sprite);

        // Forza scala fissa per evitare cambiamenti da menu
        var fixed_drag_scale = 1.5; // Scala fissa sempre uguale

        // Disegna l'item centrato sul cursore del mouse (SCALA FISSA)
        draw_sprite_ext(item_sprite, 0,
                       gui_mouse_x - sprite_w/2,
                       gui_mouse_y - sprite_h/2,
                       fixed_drag_scale, fixed_drag_scale, 0, c_white, 0.8);
    }
}