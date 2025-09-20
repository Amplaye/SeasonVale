// ===================================================================
// 🖱️ ITEM HOVER TOOLTIP - MOSTRA NOME ITEM
// ===================================================================

// Disegna tooltip solo se inventario aperto e c'è qualcosa in hover
if (global.inventory_visible && hover_tooltip_alpha > 0 && hovered_item_sprite != noone) {

    // Ottieni nome item dal description manager
    var item_name = "Oggetto Sconosciuto";
    var item_rarity = "common";

    if (instance_exists(obj_item_description_manager)) {
        item_name = obj_item_description_manager.get_item_name(hovered_item_sprite);
        item_rarity = obj_item_description_manager.get_item_rarity(hovered_item_sprite);
    }

    // Calcola posizione tooltip (vicino al mouse ma non troppo)
    var tooltip_x = mouse_x + 20;
    var tooltip_y = mouse_y - 10;

    // Assicurati che il tooltip non esca dallo schermo
    var tooltip_width = string_width(item_name) + 16;
    var tooltip_height = string_height(item_name) + 12;

    if (tooltip_x + tooltip_width > room_width) {
        tooltip_x = mouse_x - tooltip_width - 20;
    }
    if (tooltip_y < 0) {
        tooltip_y = mouse_y + 20;
    }

    // Colore basato sulla rarità
    var rarity_color = c_white;
    if (instance_exists(obj_item_description_manager)) {
        rarity_color = obj_item_description_manager.get_rarity_color(item_rarity);
    }

    // Disegna sfondo tooltip
    draw_set_alpha(hover_tooltip_alpha * 0.9);
    draw_set_color(c_black);
    draw_rectangle(tooltip_x - 8, tooltip_y - 6,
                   tooltip_x + tooltip_width - 8, tooltip_y + tooltip_height - 6, false);

    // Disegna bordo tooltip
    draw_set_alpha(hover_tooltip_alpha);
    draw_set_color(rarity_color);
    draw_rectangle(tooltip_x - 8, tooltip_y - 6,
                   tooltip_x + tooltip_width - 8, tooltip_y + tooltip_height - 6, true);

    // Disegna testo nome item
    draw_set_color(rarity_color);
    draw_set_alpha(hover_tooltip_alpha);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(tooltip_x, tooltip_y, item_name);

    // Reset draw settings
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}