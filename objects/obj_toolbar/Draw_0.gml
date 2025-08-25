// ===================================================================
// TOOLBAR SLOT DRAWING - ITEMS FISSI DENTRO SLOT
// ===================================================================

// Calcola quale slot sono io
var my_slot_index = 0;
with (obj_toolbar) {
    if (id != other.id) my_slot_index++;
    if (id == other.id) break;
}

// Controlla se il mouse è sopra questo slot
var mouse_over = point_in_rectangle(mouse_x, mouse_y, x, y, x + sprite_width, y + sprite_height);

// Disegna lo slot con sprite appropriato
var slot_sprite = tool_slot; // Sprite normale
if (global.selected_tool == my_slot_index) {
    slot_sprite = tool_slot_select; // Sprite selezione
} else if (mouse_over) {
    slot_sprite = tool_slot_hover; // Sprite hover
}
draw_sprite(slot_sprite, 0, x, y);

// Se ho un item da disegnare
if (my_slot_index < array_length(global.tool_sprites)) {
    var item_sprite = global.tool_sprites[my_slot_index];
    
    if (item_sprite != noone) {
        // Debug rimosso per ridurre spam
        
        var slot_center_x = x + (sprite_width / 2);
        var slot_center_y = y + (sprite_height / 2);
         var fixed_scale = 0.35; // Scala di default
  if (item_sprite == wood) {
      fixed_scale = 0.25; // Scala più piccola solo per wood
  }
        
        // Se è uno sprite valido, disegnalo
        if (sprite_exists(item_sprite)) {
            var item_width = sprite_get_width(item_sprite) * fixed_scale;
            var item_height = sprite_get_height(item_sprite) * fixed_scale;
            
            var item_alpha = 1.0;
            if (global.toolbar_dragging && global.toolbar_drag_from_slot == my_slot_index) {
                item_alpha = 0.3;
            }
            
            draw_sprite_ext(item_sprite, 0, 
                           slot_center_x - (item_width / 2), 
                           slot_center_y - (item_height / 2), 
                           fixed_scale, fixed_scale, 0, c_white, item_alpha);
        } else {
            // Placeholder per item non validi
            draw_set_color(c_red);
            draw_circle(slot_center_x, slot_center_y, 6, false);
            draw_set_color(c_white);
        }
        
        // Disegna quantità se > 1
        if (my_slot_index < array_length(global.tool_quantities) && global.tool_quantities[my_slot_index] > 1) {
            var quantity = global.tool_quantities[my_slot_index];
            
            // Posizione in basso a destra dello slot
            var text_x = x + sprite_width - 3;
            var text_y = y + sprite_height - 1;
            
            // Imposta allineamento
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            
            var scale = 0.3; // Scala per testo più piccolo       
            
            // Disegna testo principale
            draw_set_color(c_white);
            draw_text_transformed(text_x, text_y, string(quantity), scale, scale, 0);
            
            // Reset allineamento
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
                       
        
        // Gestione drag & drop e selezione
        if (mouse_over) {
            // Inizio drag se c'è un item in questo slot
            if (mouse_check_button_pressed(mb_left) && item_sprite != noone) {
                global.toolbar_dragging = true;
                global.toolbar_drag_from_slot = my_slot_index;
                global.toolbar_drag_item = item_sprite;
                global.toolbar_drag_start_x = mouse_x;
                global.toolbar_drag_start_y = mouse_y;
                global.selected_tool = my_slot_index;
            }
            // Selezione normale se non c'è dragging
            else if (mouse_check_button_pressed(mb_left) && !global.toolbar_dragging) {
                global.selected_tool = my_slot_index;
            }
        }
        
        // Fine drag - drop dell'item
        if (global.toolbar_dragging && mouse_check_button_released(mb_left)) {
            // Trova in quale slot rilasciare
            var drop_slot = -1;
            for (var i = 0; i < global.toolbar_slots_count; i++) {
                with (obj_toolbar) {
                    var slot_idx = 0;
                    with (obj_toolbar) {
                        if (id != other.id) slot_idx++;
                        if (id == other.id) break;
                    }
                    if (slot_idx == i) {
                        var slot_mouse_over = point_in_rectangle(mouse_x, mouse_y, x, y, x + sprite_width, y + sprite_height);
                        if (slot_mouse_over) {
                            drop_slot = i;
                            break;
                        }
                    }
                }
            }
            
            // Esegui lo swap se c'è un drop valido
            if (drop_slot != -1 && drop_slot != global.toolbar_drag_from_slot) {
                var temp_item = global.tool_sprites[drop_slot];
                var temp_quantity = global.tool_quantities[drop_slot];
                
                global.tool_sprites[drop_slot] = global.toolbar_drag_item;
                global.tool_quantities[drop_slot] = global.tool_quantities[global.toolbar_drag_from_slot];
                
                global.tool_sprites[global.toolbar_drag_from_slot] = temp_item;
                global.tool_quantities[global.toolbar_drag_from_slot] = temp_quantity;
                
                global.selected_tool = drop_slot;
            }
            
            // Reset drag state
            global.toolbar_dragging = false;
            global.toolbar_drag_from_slot = -1;
            global.toolbar_drag_item = noone;
        }
        
        // Reset colore
        draw_set_color(c_white);
    }
}