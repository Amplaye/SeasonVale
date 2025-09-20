// ===================================================================
// TOOLBAR SLOTS DRAWING - TUTTI GLI SLOT DA UNA SOLA ISTANZA
// ===================================================================

// Disegna background toolbar
var slot_scale = 0.5;
var toolbar_bg_padding_left = 5.5;   // Padding sinistro
var toolbar_bg_padding_right = 5.5;  // Padding destro  
var toolbar_bg_padding_top = 4.5;    // Padding superiore
var toolbar_bg_padding_bottom = 3.5; // Padding inferiore
var scaled_slot_width = sprite_get_width(spr_slot) * slot_scale;
var scaled_slot_height = sprite_get_height(spr_slot) * slot_scale;
var toolbar_bg_width = (global.toolbar_slots_count * scaled_slot_width) + ((global.toolbar_slots_count - 1) * global.toolbar_gap);
var toolbar_bg_x = x - toolbar_bg_padding_left;
var toolbar_bg_y = y - toolbar_bg_padding_top;
draw_sprite_stretched(spr_toolbar, 0, toolbar_bg_x, toolbar_bg_y, toolbar_bg_width + toolbar_bg_padding_left + toolbar_bg_padding_right, scaled_slot_height + toolbar_bg_padding_top + toolbar_bg_padding_bottom);

// Disegna tutti i 10 slot
for (var slot_i = 0; slot_i < global.toolbar_slots_count; slot_i++) {
    var slot_x = x + (slot_i * (scaled_slot_width + global.toolbar_gap));
    var slot_y = y;
    
    // Controlla mouse hover su questo slot
    var mouse_over = point_in_rectangle(mouse_x, mouse_y, slot_x, slot_y, slot_x + scaled_slot_width, slot_y + scaled_slot_height);

    // Disegna lo slot con sprite appropriato
    var slot_sprite = spr_slot;
    if (global.selected_tool == slot_i) {
        slot_sprite = spr_slot_select;
    } else if (mouse_over) {
        slot_sprite = spr_slot_hover;
    }
    draw_sprite_ext(slot_sprite, 0, slot_x, slot_y, slot_scale, slot_scale, 0, c_white, 1);

    // Se ho un item da disegnare in questo slot
    if (slot_i < array_length(global.tool_sprites)) {
        var item_sprite = global.tool_sprites[slot_i];
    
    if (item_sprite != noone) {
        // Debug rimosso per ridurre spam
        
            var slot_center_x = slot_x + (scaled_slot_width / 2);
            var slot_center_y = slot_y + (scaled_slot_height / 2);
        // Ottieni scala dal scaling manager (con fallback)
        var fixed_scale = 0.35; // Default
        if (variable_global_exists("sprite_scales")) {
            var sprite_name = sprite_get_name(item_sprite);
            if (variable_struct_exists(global.sprite_scales, sprite_name)) {
                var scale_data = global.sprite_scales[$ sprite_name];
                fixed_scale = scale_data.scale_x;
            }
        }
        
        // Se è uno sprite valido, disegnalo
        if (sprite_exists(item_sprite)) {
            var item_width = sprite_get_width(item_sprite) * fixed_scale;
            var item_height = sprite_get_height(item_sprite) * fixed_scale;
            
                var item_alpha = 1.0;
                // Rimuovo l'opacità durante il drag
                // if (global.toolbar_dragging && global.toolbar_drag_from_slot == slot_i) {
                //     item_alpha = 0.3;
                // }
            
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
            if (slot_i < array_length(global.tool_quantities) && global.tool_quantities[slot_i] > 1) {
                var quantity = global.tool_quantities[slot_i];
                
                // Posizione in basso a destra dello slot
                var text_x = slot_x + scaled_slot_width - 3;
                var text_y = slot_y + scaled_slot_height - 1;
            
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
                    global.toolbar_drag_from_slot = slot_i;
                    global.toolbar_drag_item = item_sprite;
                    global.toolbar_drag_start_x = mouse_x;
                    global.toolbar_drag_start_y = mouse_y;
                    global.selected_tool = slot_i;
                    show_debug_message("🖱️ DRAG INIZIATO: slot " + string(slot_i) + " sprite " + sprite_get_name(item_sprite));
                }
                // Selezione normale se non c'è dragging
                else if (mouse_check_button_pressed(mb_left) && !global.toolbar_dragging) {
                    global.selected_tool = slot_i;
                }
            }
        
        }
    }
}

// Fine drag - drop dell'item (fuori dal loop degli slot)
if (global.toolbar_dragging && mouse_check_button_released(mb_left)) {
    show_debug_message("🖱️ Mouse rilasciato durante drag - Inizio controllo drop");
    // Trova in quale slot rilasciare
    var drop_slot = -1;
    for (var i = 0; i < global.toolbar_slots_count; i++) {
        var check_slot_x = x + (i * (scaled_slot_width + global.toolbar_gap));
        var check_slot_y = y;
        
        var slot_mouse_over = point_in_rectangle(mouse_x, mouse_y, check_slot_x, check_slot_y, check_slot_x + scaled_slot_width, check_slot_y + scaled_slot_height);
        if (slot_mouse_over) {
            drop_slot = i;
            break;
        }
    }
    
    // Se rilasciato fuori dalla toolbar
    if (drop_slot == -1) {
        show_debug_message("🗑️ TROVATO: Oggetto rilasciato fuori toolbar!");
        show_debug_message("🗑️ Slot: " + string(global.toolbar_drag_from_slot));
        show_debug_message("🗑️ Sprite: " + string(global.toolbar_drag_item));
    }
    // Altrimenti esegui lo swap se c'è un drop valido
    else if (drop_slot != global.toolbar_drag_from_slot) {
        show_debug_message("🖱️ Drop su slot valido: " + string(drop_slot));
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

// Hover tooltip rimosso - solo inventario ha tooltip