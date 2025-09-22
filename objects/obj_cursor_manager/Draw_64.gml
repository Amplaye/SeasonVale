// ===================================================================
// 🖱️ CURSOR RENDERING - DISEGNO CURSOR SOPRA TUTTO
// ===================================================================

// Converti coordinate mouse per GUI
var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);

// Disegna sempre il pointer sopra tutto (menu, inventory, etc.)
draw_sprite(spr_pointer, 0, gui_mouse_x, gui_mouse_y);

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

        // Scala fissa 1.0 per drag & drop
        var drag_scale = 1.0;

        // Ottieni dimensioni sprite per centratura
        var sprite_w = sprite_get_width(item_sprite) * drag_scale;
        var sprite_h = sprite_get_height(item_sprite) * drag_scale;

        // Disegna l'item centrato sul cursore del mouse con la stessa scala della toolbar
        draw_sprite_ext(item_sprite, 0,
                       gui_mouse_x - sprite_w/2,
                       gui_mouse_y - sprite_h/2,
                       drag_scale, drag_scale, 0, c_white, 0.8);
    }
}