// ===================================================================
// 🎒 INVENTORY DRAWING - RENDERING COMPLETO
// ===================================================================


// Non disegnare se inventario è nascosto
if (!global.inventory_visible) {
    exit;
}

// Check cache solo una volta per frame
check_cache_validity();


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
// Usa valori cached per performance
var final_slot_scale = cached_final_slot_scale;
scaled_slot_width = cached_scaled_slot_width;
scaled_slot_height = cached_scaled_slot_height;

// Debug: check se cache è valida
if (array_length(slot_positions_cache) != global.inventory_total_slots) {
    show_debug_message("⚠️ Cache non inizializzata! Forzando refresh...");
    refresh_cache();
}

// Loop su tutti gli slot, ma ottimizzato per performance
for (var i = 0; i < global.inventory_total_slots; i++) {
    // Usa sempre la cache per tutti gli slot
    var cached_pos = slot_positions_cache[i];
    var slot_x = x + cached_pos[0];
    var slot_y = y + cached_pos[1];

    var is_unlocked = is_slot_unlocked(i);

    // Scegli sprite slot basato su unlock status
    var slot_sprite = is_unlocked ? spr_slot : spr_slot_blocked;
    if (is_unlocked && i < 10 && global.selected_tool == i) {
        slot_sprite = spr_slot_select;
    }

    // Disegna slot
    draw_sprite_ext(slot_sprite, 0, slot_x, slot_y, final_slot_scale, final_slot_scale, 0, c_white, 1.0);

    // Disegna item solo se slot sbloccato
    if (is_unlocked) {
        var slot_data = get_slot_data(i);
        var item_sprite = slot_data[0];
        var quantity = slot_data[1];

        if (sprite_exists(item_sprite) && quantity > 0) {
            var slot_center_x = slot_x + (scaled_slot_width * 0.5);
            var slot_center_y = slot_y + (scaled_slot_height * 0.5);

            // Ottieni scala dal scaling manager (stesso sistema della toolbar)
            var fixed_item_scale = 0.35; // Default
            if (variable_global_exists("sprite_scales")) {
                var sprite_name = sprite_get_name(item_sprite);
                if (variable_struct_exists(global.sprite_scales, sprite_name)) {
                    var scale_data = global.sprite_scales[$ sprite_name];
                    fixed_item_scale = scale_data.scale_x;
                }
            }

            // Calcolo dimensioni ottimizzato
            var half_width = sprite_get_width(item_sprite) * fixed_item_scale * 0.5;
            var half_height = sprite_get_height(item_sprite) * fixed_item_scale * 0.5;

            // Correzione specifica per spr_rock (origin point decentrato)
            var offset_x = 0;
            var offset_y = 0;
            if (item_sprite == spr_rock) {
                offset_x = 2 * fixed_item_scale; // Sposta destra per centrare
                offset_y = 2 * fixed_item_scale; // Sposta giù per centrare
            }

            // Disegna item
            draw_sprite_ext(item_sprite, 0,
                           slot_center_x - half_width + offset_x,
                           slot_center_y - half_height + offset_y,
                           fixed_item_scale, fixed_item_scale, 0, c_white, 1.0);

            // Quantità (ottimizzata)
            if (quantity > 1) {
                draw_set_color(c_white);
                draw_set_halign(fa_right);
                draw_set_valign(fa_bottom);
                draw_inventory_qty_text(slot_x + scaled_slot_width - 0,
                                    slot_y + scaled_slot_height - -2,
                                    string(quantity));
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
            }
        }
    } // End if unlocked
}

// ===================================================================
// 🖱️ ITEM HOVER TOOLTIP - MOSTRA SOLO NOME ITEM
// ===================================================================

// ===== TOOLTIP HOVER OTTIMIZZATO =====
// Mostra tooltip solo se hovered_slot è valido (ottimizzazione major)
if (global.inventory_visible && hovered_slot >= 0 && hovered_item_sprite != noone) {
    // Controlla se è uno sprite o un'istanza con sprite
    var item_sprite_to_use = hovered_item_sprite;

    // Se è un'istanza, prendi il suo sprite_index
    if (instance_exists(hovered_item_sprite)) {
        with(hovered_item_sprite) {
            if (sprite_index != -1) {
                item_sprite_to_use = sprite_index;
            }
        }
    }

    // Assicurati che sia uno sprite valido
    if (sprite_exists(item_sprite_to_use)) {
        // Ottieni nome item
        var item_name = "Oggetto";
        var item_rarity = "common";

        if (instance_exists(obj_item_description_manager)) {
            item_name = obj_item_description_manager.get_item_name(item_sprite_to_use);
            item_rarity = obj_item_description_manager.get_item_rarity(item_sprite_to_use);
        }

        // Calcola dimensioni tooltip con testo piccolo
        var text_scale = 0.3;
        var text_width = string_width(item_name) * text_scale;
        var text_height = string_height(item_name) * text_scale;

        // Posizione tooltip sopra mouse
        var tooltip_x = mouse_x - (text_width * 0.5);
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
        draw_inventory_tooltip_text(tooltip_x, tooltip_y, item_name);

        // Reset
        draw_set_alpha(1.0);
        draw_set_color(c_white);
    }
}


