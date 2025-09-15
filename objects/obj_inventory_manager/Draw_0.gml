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
draw_sprite_ext(spr_inventory, 0, bg_center_x, bg_center_y, 
                ((total_width + (bg_padding * 2)) / sprite_get_width(spr_inventory)) * global.inventory_background_scale, 
                ((total_height + (bg_padding * 2)) / sprite_get_height(spr_inventory)) * global.inventory_background_scale, 
                0, c_white, bg_alpha);

// ===== DISEGNA SLOT E ITEMS =====
for (var i = 0; i < global.inventory_total_slots; i++) {
    var slot_pos = get_slot_position(i);
    var slot_x = slot_pos[0];
    var slot_y = slot_pos[1];
    var is_unlocked = is_slot_unlocked(i);
    
    // Scegli sprite slot in base allo stato
    var slot_sprite = spr_slot;
    var slot_alpha = 1.0;
    
    if (!is_unlocked) {
        slot_sprite = spr_slot_blocked;
        slot_alpha = 1;
    }
    
    // Disegna slot usando scaling manuale
    var final_slot_scale = global.slot_scale * global.inventory_scale;
    draw_sprite_ext(slot_sprite, 0, slot_x, slot_y, final_slot_scale, final_slot_scale, 0, c_white, slot_alpha);
    
    // Se lo slot è sbloccato e ha un item, disegnalo
    if (is_unlocked) {
        var slot_data = get_slot_data(i);
        var item_sprite = slot_data[0];
        var quantity = slot_data[1];
        
        if (sprite_exists(item_sprite) && quantity > 0) {
            // Calcola centro slot (come toolbar)
            var slot_center_x = slot_x + (scaled_slot_width / 2);
            var slot_center_y = slot_y + (scaled_slot_height / 2);
            
            // Ottieni scala dal scaling manager (come toolbar)
            var fixed_scale = 0.35; // Default
            if (variable_global_exists("sprite_scales")) {
                var sprite_name = sprite_get_name(item_sprite);
                if (variable_struct_exists(global.sprite_scales, sprite_name)) {
                    var scale_data = global.sprite_scales[$ sprite_name];
                    fixed_scale = scale_data.scale_x;
                }
            }
            
            // Calcola dimensioni item
            var item_width = sprite_get_width(item_sprite) * fixed_scale;
            var item_height = sprite_get_height(item_sprite) * fixed_scale;
            
            // Disegna item centrato (come toolbar)
            draw_sprite_ext(item_sprite, 0, 
                           slot_center_x - (item_width / 2), 
                           slot_center_y - (item_height / 2), 
                           fixed_scale, fixed_scale, 0, c_white, 1.0);
            
            // Disegna quantità se > 1 (stile toolbar con scala 0.1 più grande)
            if (quantity > 1) {
                draw_set_color(c_white);
                draw_set_halign(fa_right);
                draw_set_valign(fa_bottom);
                
                var scale = 0.4; // Toolbar usa 0.3, qui 0.1 più grande
                var text_x = slot_x + scaled_slot_width - 2;
                var text_y = slot_y + scaled_slot_height - 2;
                
                draw_text_transformed(text_x, text_y, string(quantity), scale, scale, 0);
                
                // Reset text alignment
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
            }
        }
    }
    
    // Evidenzia slot attualmente selezionato dalla toolbar (se in prima riga)
    if (is_unlocked && i < 10 && variable_global_exists("selected_tool") && global.selected_tool == i) {
        // Usa blend mode additive per non coprire l'item
        gpu_set_blendmode(bm_add);
        draw_sprite_ext(spr_slot_select, 0, slot_x, slot_y, final_slot_scale, final_slot_scale, 0, c_white, 0.3);
        gpu_set_blendmode(bm_normal);
    }
}


