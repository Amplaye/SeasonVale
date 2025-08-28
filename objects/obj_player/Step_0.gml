// ===== CONTROLLO POPUP ATTIVO - BLOCCA MOVIMENTO =====
// Blocca solo se popup_active E non stiamo facendo drag & drop
var popup_blocks_movement = false;
if (variable_global_exists("popup_active") && global.popup_active) {
    // Permetti il movimento se il popup throw è attivo (per poter fare drag & drop)
    if (variable_global_exists("popup_throw_active") && global.popup_throw_active) {
        popup_blocks_movement = false;
    } else {
        popup_blocks_movement = true;
        
        // Ma permetti drag se stiamo trascinando dalla toolbar
        if (variable_global_exists("toolbar_dragging") && global.toolbar_dragging) {
            popup_blocks_movement = false;
        }
    }
}

if (popup_blocks_movement) {
    // Se il popup è attivo, blocca tutti i movimenti e passa a idle
    is_moving = false;
    hsp = 0;
    vsp = 0;
    
    // Passa allo sprite idle in base alla direzione corrente
    var idle_sprite = -1;
    switch(current_direction) {
        case "right":
            idle_sprite = idle_right;
            break;
        case "left":
            idle_sprite = idle_left;
            break;
        case "front":
            idle_sprite = idle_front;
            break;
        case "back":
            idle_sprite = idle_back;
            break;
        default:
            idle_sprite = idle_front; // Default se direzione non definita
            break;
    }
    
    // Cambia sprite solo se diverso da quello attuale
    if (idle_sprite != -1 && sprite_index != idle_sprite) {
        var old_frame = image_index;
        var old_speed = image_speed;
        var old_sprite = sprite_index;
        
        var old_visual_x = x - sprite_get_xoffset(old_sprite);
        var old_visual_y = y - sprite_get_yoffset(old_sprite);
        
        sprite_index = idle_sprite;
        
        x = old_visual_x + sprite_get_xoffset(idle_sprite);
        y = old_visual_y + sprite_get_yoffset(idle_sprite);
        
        if (sprite_get_number(sprite_index) > 0) {
            var frame_ratio = old_frame / max(sprite_get_number(sprite_index), 1);
            image_index = frame_ratio * sprite_get_number(sprite_index);
            image_index = clamp(image_index, 0, sprite_get_number(sprite_index) - 1);
        }
        image_speed = old_speed;
    }
    
    exit; // Esci dal Step event senza fare altro
}

// ===== NOTIFICA CURSOR MANAGER DEL CLICK =====
// RIMOSSO: animazione click cursor non più necessaria

// ===== CHOPPING SYSTEM =====
// Controlla se l'axe è selezionato e click sinistro
if (mouse_check_button_pressed(mb_left)) {
    // Non avviare chopping se il click è sulla toolbar (y >= 220)
    // O se un popup è attivo
    var is_click_on_toolbar = (mouse_y >= 220);
    var popup_is_active = (variable_global_exists("popup_active") && global.popup_active) ||
                         (variable_global_exists("popup_throw_active") && global.popup_throw_active);
    
    if (!is_click_on_toolbar && !popup_is_active) {
        var selected_tool_sprite = noone;
        if (global.selected_tool >= 0 && global.selected_tool < array_length(global.tool_sprites)) {
            selected_tool_sprite = global.tool_sprites[global.selected_tool];
        }
        
        if (selected_tool_sprite == axe) {
        // Avvia animazione chopping
        if (!is_chopping) {
            is_chopping = true;
            
            // Salva sprite attuale e posizione
            var old_sprite = sprite_index;
            var saved_x = x;
            var saved_y = y;
            
            // Calcola direzione verso il cursor
            var cursor_direction = get_direction_to_cursor();
            
            // Aggiorna la direzione corrente del player per seguire il cursor
            current_direction = cursor_direction;
            
            // Scegli animazione in base alla direzione verso il cursor
            var chop_sprite = chop_right; // Default
            switch(cursor_direction) {
                case "right":
                    chop_sprite = chop_right;
                    break;
                case "left":
                    chop_sprite = chop_left;
                    break;
                case "front":
                    chop_sprite = chop_front;
                    break;
                case "back":
                    chop_sprite = chop_back;
                    break;
                default:
                    chop_sprite = chop_right;
                    break;
            }
            
            // Gestisci correttamente il cambio sprite con offset
            var old_visual_x = x - sprite_get_xoffset(old_sprite);
            var old_visual_y = y - sprite_get_yoffset(old_sprite);
            
            sprite_index = chop_sprite;
            image_index = 0;
            image_speed = 0;
            
            // Riposiziona correttamente con il nuovo offset
            x = old_visual_x + sprite_get_xoffset(chop_sprite);
            y = old_visual_y + sprite_get_yoffset(chop_sprite);
            
            chopping_original_x = x;
            chopping_original_y = y;
            
            // DEBUG: Mostra informazioni dettagliate degli sprite
            show_debug_message("🪓 Chopping " + cursor_direction + " animation started (cursor direction)");
            show_debug_message("OLD SPRITE (" + sprite_get_name(old_sprite) + "):");
            show_debug_message("  - Size: " + string(sprite_get_width(old_sprite)) + "x" + string(sprite_get_height(old_sprite)));
            show_debug_message("  - Offset: " + string(sprite_get_xoffset(old_sprite)) + "," + string(sprite_get_yoffset(old_sprite)));
            show_debug_message("  - BBox: " + string(sprite_get_bbox_left(old_sprite)) + "," + string(sprite_get_bbox_top(old_sprite)) + " to " + string(sprite_get_bbox_right(old_sprite)) + "," + string(sprite_get_bbox_bottom(old_sprite)));
            
            show_debug_message("NEW SPRITE (" + sprite_get_name(chop_sprite) + "):");
            show_debug_message("  - Size: " + string(sprite_get_width(chop_sprite)) + "x" + string(sprite_get_height(chop_sprite)));
            show_debug_message("  - Offset: " + string(sprite_get_xoffset(chop_sprite)) + "," + string(sprite_get_yoffset(chop_sprite)));
            show_debug_message("  - BBox: " + string(sprite_get_bbox_left(chop_sprite)) + "," + string(sprite_get_bbox_top(chop_sprite)) + " to " + string(sprite_get_bbox_right(chop_sprite)) + "," + string(sprite_get_bbox_bottom(chop_sprite)));
        }
        }
    }
}

// Controlla fine animazione chopping - controllo manuale
if (is_chopping) {
    // Avanza manualmente l'animazione
    image_index += 0.2; // Velocità controllata manualmente
    
    // Quando raggiunge l'ultimo frame, ferma
    if (image_index >= sprite_get_number(sprite_index)) {
        is_chopping = false;
        show_debug_message("🪓 Chopping animation finished");
        
        // Forza il ritorno all'animazione idle corretta
        var idle_sprite = -1;
        switch(current_direction) {
            case "right":
                idle_sprite = idle_right;
                break;
            case "left":
                idle_sprite = idle_left;
                break;
            case "front":
                idle_sprite = idle_front;
                break;
            case "back":
                idle_sprite = idle_back;
                break;
            default:
                idle_sprite = idle_front;
                break;
        }
        
        if (idle_sprite != -1) {
            // Gestisci correttamente il cambio sprite con offset
            var old_visual_x = x - sprite_get_xoffset(sprite_index);
            var old_visual_y = y - sprite_get_yoffset(sprite_index);
            
            sprite_index = idle_sprite;
            image_index = 0;
            image_speed = 1.0;
            
            // Riposiziona correttamente con il nuovo offset
            x = old_visual_x + sprite_get_xoffset(idle_sprite);
            y = old_visual_y + sprite_get_yoffset(idle_sprite);
            
            show_debug_message("🪓 Ripristinato sprite idle: " + sprite_get_name(idle_sprite));
        }
    }
    // Se in chopping, blocca il movimento
    if (is_chopping) {
        exit;
    }
}

var left = keyboard_check(ord("A")) || keyboard_check(vk_left);
var right = keyboard_check(ord("D")) || keyboard_check(vk_right);
var up = keyboard_check(ord("W")) || keyboard_check(vk_up);
var down = keyboard_check(ord("S")) || keyboard_check(vk_down);
var run = keyboard_check(vk_shift);

var move_speed = run ? speed_run : speed_walk;

hsp = 0;
vsp = 0;

if (left && !right) {
    hsp = -1;
}
if (right && !left) {
    hsp = 1;
}
if (up && !down) {
    vsp = -1;
}
if (down && !up) {
    vsp = 1;
}

if (hsp != 0 || vsp != 0) {
    var length = sqrt(hsp * hsp + vsp * vsp);
    hsp = (hsp / length) * move_speed;
    vsp = (vsp / length) * move_speed;
}

is_moving = (hsp != 0) || (vsp != 0);

if (is_moving) {
    x += hsp;
    y += vsp;
    
    var new_sprite = -1;
    var new_direction = "";
    
    if (hsp != 0 && vsp != 0) {
        if (current_direction == "right" || current_direction == "left") {
            if (abs(hsp) >= abs(vsp) * 0.7) {
                if (hsp > 0) {
                    new_direction = "right";
                    new_sprite = run_right;
                }
                else {
                    new_direction = "left";
                    new_sprite = run_left;
                }
            } else {
                if (vsp > 0) {
                    new_direction = "front";
                    new_sprite = run_front;
                }
                else {
                    new_direction = "back";
                    new_sprite = run_back;
                }
            }
        } else {
            if (abs(vsp) >= abs(hsp) * 0.7) {
                if (vsp > 0) {
                    new_direction = "front";
                    new_sprite = run_front;
                }
                else {
                    new_direction = "back";
                    new_sprite = run_back;
                }
            } else {
                if (hsp > 0) {
                    new_direction = "right";
                    new_sprite = run_right;
                }
                else {
                    new_direction = "left";
                    new_sprite = run_left;
                }
            }
        }
    }
    else if (hsp > 0) {
        new_direction = "right";
        new_sprite = run_right;
    }
    else if (hsp < 0) {
        new_direction = "left";
        new_sprite = run_left;
    }
    else if (vsp > 0) {
        new_direction = "front";
        new_sprite = run_front;
    }
    else if (vsp < 0) {
        new_direction = "back";
        new_sprite = run_back;
    }
    
    if (new_sprite != -1) {
        current_direction = new_direction;
        if (sprite_index != new_sprite) {
            var old_frame = image_index;
            var old_speed = image_speed;
            var old_sprite = sprite_index;
            
            var old_visual_x = x - sprite_get_xoffset(old_sprite);
            var old_visual_y = y - sprite_get_yoffset(old_sprite);
            
            sprite_index = new_sprite;
            
            x = old_visual_x + sprite_get_xoffset(new_sprite);
            y = old_visual_y + sprite_get_yoffset(new_sprite);
            
            if (sprite_get_number(sprite_index) > 0) {
                var frame_ratio = old_frame / max(sprite_get_number(sprite_index), 1);
                image_index = frame_ratio * sprite_get_number(sprite_index);
                image_index = clamp(image_index, 0, sprite_get_number(sprite_index) - 1);
            }
            image_speed = old_speed;
        }
    }
} else {
    var new_sprite = -1;
    
    switch(current_direction) {
        case "right":
            new_sprite = idle_right;
            break;
        case "left":
            new_sprite = idle_left;
            break;
        case "front":
            new_sprite = idle_front;
            break;
        case "back":
            new_sprite = idle_back;
            break;
        default:
            new_sprite = idle_front;
            break;
    }
    
    if (new_sprite != -1 && sprite_index != new_sprite) {
        var old_frame = image_index;
        var old_speed = image_speed;
        var old_sprite = sprite_index;
        
        var old_visual_x = x - sprite_get_xoffset(old_sprite);
        var old_visual_y = y - sprite_get_yoffset(old_sprite);
        
        sprite_index = new_sprite;
        
        x = old_visual_x + sprite_get_xoffset(new_sprite);
        y = old_visual_y + sprite_get_yoffset(new_sprite);
        
        if (sprite_get_number(sprite_index) > 0) {
            var frame_ratio = old_frame / max(sprite_get_number(sprite_index), 1);
            image_index = frame_ratio * sprite_get_number(sprite_index);
            image_index = clamp(image_index, 0, sprite_get_number(sprite_index) - 1);
        }
        image_speed = old_speed;
    }
}