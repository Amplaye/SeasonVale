
// ===== SISTEMA HARVESTING INDIPENDENTE =====
// Reset harvest flag ogni frame
global.harvest_this_frame = false;

// Gestisce il raccolto delle piante basato sulla posizione del mouse
if (mouse_check_button_pressed(mb_right) && !global.harvest_this_frame) {
    // Debug generale del sistema
    show_debug_message("🖱️ Click destro rilevato nel player");

    // Converti coordinate mouse da view a mondo
    var cam = camera_get_active();
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var world_mouse_x = mouse_x + view_x;
    var world_mouse_y = mouse_y + view_y;

    // Trova la pianta più vicina al mouse che può essere raccolta
    var closest_plant = noone;
    var closest_distance = 999999;
    var max_harvest_distance = 20; // Distanza massima per harvest (molto piccola)
    var player_range = 48; // Distanza massima dal player

    with (obj_universal_plant) {
        if (can_harvest && harvest_cooldown <= 0) {
            // Controlla distanza dal player
            var dist_to_player = point_distance(x, y, other.x, other.y);
            if (dist_to_player <= player_range) {
                // Controlla distanza dal mouse
                var dist_to_mouse = point_distance(x, y, world_mouse_x, world_mouse_y);
                if (dist_to_mouse <= max_harvest_distance && dist_to_mouse < closest_distance) {
                    closest_distance = dist_to_mouse;
                    closest_plant = id;
                }
            }
        }
    }

    // Se abbiamo trovato una pianta, raccoglila
    if (closest_plant != noone) {
        global.harvest_this_frame = true;
        harvest_plant_universal(closest_plant);
        show_debug_message("🌾 Pianta raccolta direttamente dal player! ID: " + string(closest_plant));
    } else {
        show_debug_message("❌ Click destro ma nessuna pianta nel raggio (max: " + string(max_harvest_distance) + " pixel)");
    }
}

// ===== HIGHLIGHT SISTEMA SEPARATO =====
// Aggiorna highlight per tutte le piante ogni frame
var cam = camera_get_active();
var view_x = camera_get_view_x(cam);
var view_y = camera_get_view_y(cam);
var world_mouse_x = mouse_x + view_x;
var world_mouse_y = mouse_y + view_y;

// Reset highlight per tutte le piante
with (obj_universal_plant) {
    if (variable_instance_exists(id, "is_highlighted")) {
        is_highlighted = false;
    }
}

// Trova la pianta più vicina al mouse per highlight
var closest_plant_highlight = noone;
var closest_distance_highlight = 999999;
var max_harvest_distance = 20;
var player_range = 48;

with (obj_universal_plant) {
    if (can_harvest && harvest_cooldown <= 0) {
        var dist_to_player = point_distance(x, y, other.x, other.y);
        if (dist_to_player <= player_range) {
            var dist_to_mouse = point_distance(x, y, world_mouse_x, world_mouse_y);
            if (dist_to_mouse <= max_harvest_distance && dist_to_mouse < closest_distance_highlight) {
                closest_distance_highlight = dist_to_mouse;
                closest_plant_highlight = id;
            }
        }
    }
}

// Evidenzia la pianta selezionabile
if (closest_plant_highlight != noone) {
    with (closest_plant_highlight) {
        is_highlighted = true;
    }
}

// ===== INIZIALIZZAZIONE DIRETTA VARIABILI =====
if (!variable_global_exists("player_initialized")) {
    global.player_initialized = true;
    can_move = true;
    chop_cooldown = 0;
    is_moving = false;
    hsp = 0;
    vsp = 0;
    current_direction = "front";
    is_chopping = false;
    is_mining = false;
    speed_walk = 2;
    speed_run = 4;
    chopping_original_x = 0;
    chopping_original_y = 0;
    mining_original_x = 0;
    mining_original_y = 0;
    mining_direction = "front";
    chopping_direction = "front";
}

// ===== DEBUG COLLISION - SEMPRE ATTIVO =====
// Collision debug è sempre visibile - bordi gialli su player e NPCs

// DEBUG: Cerca casa
if (keyboard_check_pressed(ord("H"))) {
    var house = instance_find(obj_house, 0);
    if (house != noone) {
        show_debug_message("Casa trovata a: " + string(house.x) + ", " + string(house.y));
        x = house.x;
        y = house.y + 50; // Teleporta player vicino alla casa
    } else {
        show_debug_message("CASA NON TROVATA!");
    }
}

// ===== COOLDOWN CHOP =====
if (chop_cooldown > 0) {
    chop_cooldown--;
}

// ===== CONTROLLO MOVIMENTO BLOCCATO =====
var movement_blocked = (variable_instance_exists(id, "can_move") && !can_move);
if (movement_blocked) {
    is_moving = false;
    hsp = 0;
    vsp = 0;
    
    // Passa allo sprite idle in base alla direzione corrente
    var idle_sprite = -1;
    switch(current_direction) {
        case "right":
            idle_sprite = spr_idle_right;
            break;
        case "left":
            idle_sprite = spr_idle_left;
            break;
        case "front":
            idle_sprite = spr_idle_front;
            break;
        case "back":
            idle_sprite = spr_idle_back;
            break;
        default:
            idle_sprite = spr_idle_front;
            break;
    }
    
    if (idle_sprite != -1 && sprite_index != idle_sprite && !is_chopping && !is_mining) {
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
    
    exit;
}

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
            idle_sprite = spr_idle_right;
            break;
        case "left":
            idle_sprite = spr_idle_left;
            break;
        case "front":
            idle_sprite = spr_idle_front;
            break;
        case "back":
            idle_sprite = spr_idle_back;
            break;
        default:
            idle_sprite = spr_idle_front; // Default se direzione non definita
            break;
    }
    
    // Cambia sprite solo se diverso da quello attuale E non stiamo choppando
    if (idle_sprite != -1 && sprite_index != idle_sprite && !is_chopping && !is_mining) {
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
        
        
        // CONTROLLO PICKAXE PER PRIMO
        if (global.selected_tool == 1 && chop_cooldown <= 0) {
            if (!is_mining && !is_chopping) {
                is_mining = true;
                
                // Salva posizione originale
                mining_original_x = x;
                mining_original_y = y;
                
                // Calcola direzione verso il cursor
                var cursor_x = mouse_x;
                var cursor_y = mouse_y;
                var angle_to_cursor = point_direction(x, y, cursor_x, cursor_y);
                
                // Determina direzione mining basata sull'angolo
                if (angle_to_cursor >= 315 || angle_to_cursor < 45) {
                    mining_direction = "right";
                } else if (angle_to_cursor >= 45 && angle_to_cursor < 135) {
                    mining_direction = "back";
                } else if (angle_to_cursor >= 135 && angle_to_cursor < 225) {
                    mining_direction = "left";
                } else {
                    mining_direction = "front";
                }
                
                // Per ora usa sprite chopping (quando avrai animazioni mining sostituisci qui)
                var mining_sprite = -1;
                switch(mining_direction) {
                    case "front": mining_sprite = spr_chop_front; break;
                    case "back": mining_sprite = spr_chop_back; break;
                    case "left": mining_sprite = spr_chop_left; break;
                    case "right": mining_sprite = spr_chop_right; break;
                }
                
                if (mining_sprite != -1) {
                    sprite_index = mining_sprite;
                    image_index = 0;
                }
            }
        }
        
        if (selected_tool_sprite == spr_axe && chop_cooldown <= 0) {
            // Avvia animazione chopping
            if (!is_chopping && !is_mining) {
            is_chopping = true;
            
            // Salva sprite attuale e posizione
            var old_sprite = sprite_index;
            var saved_x = x;
            var saved_y = y;
            
            // Calcola direzione verso il cursor
            var cursor_direction = get_direction_to_cursor();
            
            // Salva la direzione del chop (siamo all'inizio dell'animazione)
            current_direction = cursor_direction;
            chopping_direction = cursor_direction; // Salva direzione per questa animazione
            
            // Usa la direzione salvata per l'animazione chop
            var chop_sprite = spr_chop_right; // Default
            switch(chopping_direction) {
                case "right":
                    chop_sprite = spr_chop_right;
                    break;
                case "left":
                    chop_sprite = spr_chop_left;
                    break;
                case "front":
                    chop_sprite = spr_chop_front;
                    break;
                case "back":
                    chop_sprite = spr_chop_back;
                    break;
                default:
                    chop_sprite = spr_chop_right;
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
        }
        
        // Confronto diretto per pickaxe - slot 1
        var is_pickaxe = (global.selected_tool == 1); 
        
        if (is_pickaxe && chop_cooldown <= 0) {
        
        // Avvia animazione mining
        if (!is_mining) {
            is_mining = true;
            
            // Salva sprite attuale e posizione
            var old_sprite = sprite_index;
            var saved_x = x;
            var saved_y = y;
            
            // Calcola direzione verso il cursor
            var cursor_x = mouse_x;
            var cursor_y = mouse_y;
            var angle_to_cursor = point_direction(x, y, cursor_x, cursor_y);
            
            // Determina direzione mining basata sull'angolo
            if (angle_to_cursor >= 315 || angle_to_cursor < 45) {
                mining_direction = "right";
            } else if (angle_to_cursor >= 45 && angle_to_cursor < 135) {
                mining_direction = "back";
            } else if (angle_to_cursor >= 135 && angle_to_cursor < 225) {
                mining_direction = "left";
            } else {
                mining_direction = "front";
            }
            
            // Salva posizione originale
            mining_original_x = x;
            mining_original_y = y;
            
            // Per ora usa stesso sprite del front (quando avrai animazioni mining le aggiungi qui)
            var mining_sprite = -1;
            switch(mining_direction) {
                case "front": mining_sprite = spr_chop_front; break;
                case "back": mining_sprite = spr_chop_back; break;
                case "left": mining_sprite = spr_chop_left; break;
                case "right": mining_sprite = spr_chop_right; break;
            }
            
            if (mining_sprite != -1) {
                sprite_index = mining_sprite;
                image_index = 0;
            }
        }
        }
        }
    }
}

// BLOCCA TUTTO DURANTE IL CHOPPING
if (is_chopping) {
    // Avanza manualmente l'animazione
    image_index += 0.2; // Velocità controllata manualmente
    
    // Quando raggiunge l'ultimo frame, ferma
    if (image_index >= sprite_get_number(sprite_index)) {
        is_chopping = false;
        
        // Controlla se abbiamo colpito un albero
        var tree_hit = noone;
        var hit_distance = 40; // Distanza massima per colpire l'albero
        
        // Calcola posizione di attacco basata sulla direzione
        var attack_x = x;
        var attack_y = y;
        
        switch(chopping_direction) {
            case "right":
                attack_x = x + hit_distance;
                break;
            case "left":
                attack_x = x - hit_distance;
                break;
            case "front":
                attack_y = y + hit_distance;
                break;
            case "back":
                attack_y = y - hit_distance;
                break;
        }
        
        // Cerca alberi vicini alla posizione di attacco
        tree_hit = instance_nearest(attack_x, attack_y, obj_tree);
        if (tree_hit != noone && point_distance(attack_x, attack_y, tree_hit.x, tree_hit.y) <= hit_distance) {
            // Attiva effetto shake sull'albero (ridotto del 50%)
            tree_hit.shake_timer = 30; // 30 frame di shake
            tree_hit.shake_intensity = 1.5; // Intensità iniziale ridotta del 50%
            tree_hit.shake_direction = point_direction(tree_hit.x, tree_hit.y, x, y); // Direzione opposta al player
        }
        
        // Forza il ritorno all'animazione idle corretta
        var idle_sprite = -1;
        switch(chopping_direction) { // Usa chopping_direction per l'idle
            case "right":
                idle_sprite = spr_idle_right;
                break;
            case "left":
                idle_sprite = spr_idle_left;
                break;
            case "front":
                idle_sprite = spr_idle_front;
                break;
            case "back":
                idle_sprite = spr_idle_back;
                break;
            default:
                idle_sprite = spr_idle_front;
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
            
            current_direction = chopping_direction; // Aggiorna current_direction
            chop_cooldown = 20; // 30 frame di cooldown (circa 0.5 secondi)
        }
    }
    
    // BLOCCA COMPLETAMENTE TUTTO IL RESTO DEL CODICE
    exit;
}

// BLOCCA TUTTO DURANTE IL MINING
if (is_mining) {
    // Avanza manualmente l'animazione
    image_index += 0.2; // Velocità controllata manualmente
    
    // Quando raggiunge l'ultimo frame, ferma
    if (image_index >= sprite_get_number(sprite_index)) {
        is_mining = false;
        
        // Controlla se abbiamo colpito una roccia
        var rock_hit = noone;
        var hit_distance = 40; // Distanza massima per colpire la roccia
        
        // Calcola posizione di attacco basata sulla direzione
        var attack_x = x;
        var attack_y = y;
        
        switch(mining_direction) {
            case "right":
                attack_x = x + hit_distance;
                break;
            case "left":
                attack_x = x - hit_distance;
                break;
            case "back":
                attack_y = y - hit_distance;
                break;
            case "front":
                attack_y = y + hit_distance;
                break;
        }
        
        // Cerca roccia nel raggio di attacco
        var rocks = instance_place(attack_x, attack_y, obj_rock);
        if (rocks != noone) {
            rock_hit = rocks;
        }
        
        if (rock_hit == noone) {
            // Cerca in un'area più ampia
            rock_hit = instance_nearest(attack_x, attack_y, obj_rock);
            if (rock_hit != noone && point_distance(attack_x, attack_y, rock_hit.x, rock_hit.y) > hit_distance) {
                rock_hit = noone;
            }
        }
        
        // Ripristina sprite originale e posizione
        x = mining_original_x;
        y = mining_original_y;
        
        if (rock_hit != noone) {
            show_debug_message("Roccia colpita: " + string(rock_hit));
        }
        
        // Aggiorna current_direction per mantenere coerenza
        current_direction = mining_direction; // Aggiorna current_direction
        chop_cooldown = 25; // Cooldown più lungo per mining
    }
    
    // BLOCCA COMPLETAMENTE TUTTO IL RESTO DEL CODICE
    exit;
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


// Push out semplice - obj_collision_block + NPCs (disabilitato temporaneamente durante transizioni)
if ((collision_at_feet(x, y, obj_collision_block) || collision_at_feet(x, y, obj_npc_base)) && (!variable_global_exists("disable_pushout") || !global.disable_pushout)) {
    for (var push_dist = 1; push_dist <= 5; push_dist++) {
        if (!collision_at_feet(x - push_dist, y, obj_collision_block) && !collision_at_feet(x - push_dist, y, obj_npc_base)) {
            x -= push_dist;
            break;
        } else if (!collision_at_feet(x + push_dist, y, obj_collision_block) && !collision_at_feet(x + push_dist, y, obj_npc_base)) {
            x += push_dist;
            break;
        } else if (!collision_at_feet(x, y - push_dist, obj_collision_block) && !collision_at_feet(x, y - push_dist, obj_npc_base)) {
            y -= push_dist;
            break;
        } else if (!collision_at_feet(x, y + push_dist, obj_collision_block) && !collision_at_feet(x, y + push_dist, obj_npc_base)) {
            y += push_dist;
            break;
        }
    }
}

if (is_moving) {
    // Movimento orizzontale - obj_collision_block + NPCs
    if (hsp != 0) {
        if (!collision_feet_horizontal(x + hsp, y, obj_collision_block) && !collision_feet_horizontal(x + hsp, y, obj_npc_base)) {
            x += hsp;
        } else {
            // Movimento pixel per pixel fino al contatto
            var step_x = sign(hsp);
            while (step_x != 0 && !collision_feet_horizontal(x + step_x, y, obj_collision_block) && !collision_feet_horizontal(x + step_x, y, obj_npc_base)) {
                x += step_x;
            }
        }
    }

    // Movimento verticale - obj_collision_block + NPCs
    if (vsp != 0) {
        if (!collision_feet_vertical(x, y + vsp, obj_collision_block) && !collision_feet_vertical(x, y + vsp, obj_npc_base)) {
            y += vsp;
        } else {
            // Movimento pixel per pixel fino al contatto
            var step_y = sign(vsp);
            while (step_y != 0 && !collision_feet_vertical(x, y + step_y, obj_collision_block) && !collision_feet_vertical(x, y + step_y, obj_npc_base)) {
                y += step_y;
            }
        }
    }
    
    var new_sprite = -1;
    var new_direction = "";
    
    if (hsp != 0 && vsp != 0) {
        if (current_direction == "right" || current_direction == "left") {
            if (abs(hsp) >= abs(vsp) * 0.7) {
                if (hsp > 0) {
                    new_direction = "right";
                    new_sprite = spr_run_right;
                }
                else {
                    new_direction = "left";
                    new_sprite = spr_run_left;
                }
            } else {
                if (vsp > 0) {
                    new_direction = "front";
                    new_sprite = spr_run_front;
                }
                else {
                    new_direction = "back";
                    new_sprite = spr_run_back;
                }
            }
        } else {
            if (abs(vsp) >= abs(hsp) * 0.7) {
                if (vsp > 0) {
                    new_direction = "front";
                    new_sprite = spr_run_front;
                }
                else {
                    new_direction = "back";
                    new_sprite = spr_run_back;
                }
            } else {
                if (hsp > 0) {
                    new_direction = "right";
                    new_sprite = spr_run_right;
                }
                else {
                    new_direction = "left";
                    new_sprite = spr_run_left;
                }
            }
        }
    }
    else if (hsp > 0) {
        new_direction = "right";
        new_sprite = spr_run_right;
    }
    else if (hsp < 0) {
        new_direction = "left";
        new_sprite = spr_run_left;
    }
    else if (vsp > 0) {
        new_direction = "front";
        new_sprite = spr_run_front;
    }
    else if (vsp < 0) {
        new_direction = "back";
        new_sprite = spr_run_back;
    }
    
    if (new_sprite != -1) {
        current_direction = new_direction;
        if (sprite_index != new_sprite && !is_chopping && !is_mining) {
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
            new_sprite = spr_idle_right;
            break;
        case "left":
            new_sprite = spr_idle_left;
            break;
        case "front":
            new_sprite = spr_idle_front;
            break;
        case "back":
            new_sprite = spr_idle_back;
            break;
        default:
            new_sprite = spr_idle_front;
            break;
    }
    
    if (new_sprite != -1 && sprite_index != new_sprite && !is_chopping && !is_mining) {
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

// Depth rimosso - sarà impostato direttamente nell'editor