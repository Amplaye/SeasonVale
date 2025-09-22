// ===================================================================
// 🎒 INVENTORY DRAWING - RENDERING COMPLETO
// ===================================================================


// Non disegnare se inventario è nascosto
if (!global.inventory_visible) {
    exit;
}


// ===== DISEGNA BACKGROUND INVENTARIO =====
var bg_alpha = 0.8;
// Centra il background rispetto agli slot
var bg_padding = 8;
var bg_x = x - bg_padding;
var bg_y = y - bg_padding;

// Calcola dimensioni background usando scaling manuale
var scaled_slot_width = sprite_get_width(spr_slot) * global.slot_scale * global.inventory_scale;
var scaled_slot_height = sprite_get_height(spr_slot) * global.slot_scale * global.inventory_scale;
var total_width = (global.inventory_cols * scaled_slot_width) + ((global.inventory_cols - 1) * global.inventory_gap_x);
var total_height = (global.inventory_rows * scaled_slot_height) + ((global.inventory_rows - 1) * global.inventory_gap_y);

// Disegna sfondo inventario centrato perfettamente
var bg_center_x = x + (total_width / 2);
var bg_center_y = y + (total_height / 2);

// Verifica che lo sprite esista prima di disegnarlo
if (sprite_exists(spr_inventory)) {
    draw_sprite_ext(spr_inventory, 0, bg_center_x, bg_center_y,
                    ((total_width + (bg_padding * 2)) / sprite_get_width(spr_inventory)) * global.inventory_background_scale,
                    ((total_height + (bg_padding * 2)) / sprite_get_height(spr_inventory)) * global.inventory_background_scale,
                    0, c_white, bg_alpha);
} else {
    // Fallback: disegna un rettangolo se lo sprite non esiste
    draw_set_color(c_dkgray);
    draw_set_alpha(bg_alpha);
    draw_rectangle(bg_x, bg_y, bg_x + total_width + (bg_padding * 2), bg_y + total_height + (bg_padding * 2), false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

// ===== DISEGNA SLOT E ITEMS OTTIMIZZATO =====
// Precalcola valori comuni per performance
var final_slot_scale = global.slot_scale * global.inventory_scale;
var fixed_item_scale = 0.35;

for (var i = 0; i < global.inventory_total_slots; i++) {
    var slot_pos = get_slot_position(i);
    var slot_x = slot_pos[0];
    var slot_y = slot_pos[1];
    var is_unlocked = is_slot_unlocked(i);

    // Scegli sprite slot (minimizzato)
    var slot_sprite = is_unlocked ? spr_slot : spr_slot_blocked;
    if (is_unlocked && i < 10 && global.selected_tool == i) {
        slot_sprite = spr_slot_select;
    }

    // Disegna slot
    draw_sprite_ext(slot_sprite, 0, slot_x, slot_y, final_slot_scale, final_slot_scale, 0, c_white, 1.0);

    // Disegna item solo se slot sbloccato (ottimizzazione)
    if (is_unlocked) {
        var slot_data = get_slot_data(i);
        var item_sprite = slot_data[0];
        var quantity = slot_data[1];

        if (sprite_exists(item_sprite) && quantity > 0) {
            var slot_center_x = slot_x + (scaled_slot_width / 2);
            var slot_center_y = slot_y + (scaled_slot_height / 2);

            // Calcolo dimensioni ottimizzato
            var half_width = sprite_get_width(item_sprite) * fixed_item_scale * 0.5;
            var half_height = sprite_get_height(item_sprite) * fixed_item_scale * 0.5;

            // Disegna item
            draw_sprite_ext(item_sprite, 0,
                           slot_center_x - half_width,
                           slot_center_y - half_height,
                           fixed_item_scale, fixed_item_scale, 0, c_white, 1.0);

            // Quantità (ottimizzata)
            if (quantity > 1) {
                draw_set_color(c_white);
                draw_set_halign(fa_right);
                draw_set_valign(fa_bottom);
                draw_text_transformed(slot_x + scaled_slot_width - 2,
                                    slot_y + scaled_slot_height - 2,
                                    string(quantity), 0.4, 0.4, 0);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
            }
        }
    }
}

// ===================================================================
// 🖱️ ITEM HOVER TOOLTIP - MOSTRA SOLO NOME ITEM
// ===================================================================

// ===== TOOLTIP HOVER SEMPLICE =====
if (global.inventory_visible) {
    // Hover detection su tutti gli slot
    for (var i = 0; i < global.inventory_total_slots; i++) {
        var slot_pos = get_slot_position(i);
        var slot_x = slot_pos[0];
        var slot_y = slot_pos[1];
        var mouse_over = point_in_rectangle(mouse_x, mouse_y, slot_x, slot_y, slot_x + scaled_slot_width, slot_y + scaled_slot_height);

        if (mouse_over && is_slot_unlocked(i)) {
            var slot_data = get_slot_data(i);
            var item_sprite = slot_data[0];

            if (item_sprite != noone && slot_data[1] > 0) {
                // Ottieni nome item
                var item_name = "Oggetto";
                var item_rarity = "common";

                if (instance_exists(obj_item_description_manager)) {
                    item_name = obj_item_description_manager.get_item_name(item_sprite);
                    item_rarity = obj_item_description_manager.get_item_rarity(item_sprite);
                }

                // Calcola dimensioni tooltip con testo piccolo
                var text_scale = 0.3; // 70% più piccolo
                var text_width = string_width(item_name) * text_scale;
                var text_height = string_height(item_name) * text_scale;

                // Posizione tooltip sopra mouse
                var tooltip_x = mouse_x - (text_width / 2);
                var tooltip_y = mouse_y - 35;
                var padding = 4;

                // Colore rarità
                var rarity_color = c_white;
                if (instance_exists(obj_item_description_manager)) {
                    rarity_color = obj_item_description_manager.get_rarity_color(item_rarity);
                }

                // Sfondo tooltip con bordo
                draw_set_alpha(0.9);
                draw_set_color(c_black);
                draw_rectangle(tooltip_x - padding, tooltip_y - padding,
                             tooltip_x + text_width + padding, tooltip_y + text_height + padding, false);

                draw_set_alpha(1.0);
                draw_set_color(rarity_color);
                draw_rectangle(tooltip_x - padding, tooltip_y - padding,
                             tooltip_x + text_width + padding, tooltip_y + text_height + padding, true);

                // Testo nome item piccolo
                draw_set_color(rarity_color);
                draw_text_transformed(tooltip_x, tooltip_y, item_name, text_scale, text_scale, 0);

                // Reset
                draw_set_alpha(1.0);
                draw_set_color(c_white);
                break;
            }
        }
    }
}


