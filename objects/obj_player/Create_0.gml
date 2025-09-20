if (instance_number(obj_player) > 1) {
    instance_destroy();
    exit;
}

// Inizializza variabili di transizione
if (!variable_global_exists("transitioning")) {
    global.transitioning = false;
}
if (!variable_global_exists("disable_pushout")) {
    global.disable_pushout = false;
}

// Variabili di istanza per transition target
has_transition_target = false;
target_x = 0;
target_y = 0;

// Funzioni per collision detection sui piedi del player
// Collision mask is set in the object editor (spr_idle_front)

// NOTA: Se origin è bottom center, y è già ai piedi!
function collision_at_feet(_x, _y, _object) {
    return place_meeting(_x, _y, _object);
}

function collision_feet_horizontal(_x, _y, _object) {
    return place_meeting(_x, _y, _object);
}

function collision_feet_vertical(_x, _y, _object) {
    return place_meeting(_x, _y, _object);
}

// Riferimenti sprite tools (per confronti) - usa direttamente i nomi
// axe e pickaxe sono già disponibili globalmente come sprite resources

speed_walk = 2;
speed_run = 4;

hsp = 0;
vsp = 0;

current_direction = "idle";
is_moving = false;
can_move = true;

// Variabili per sistema chopping
is_chopping = false;
chopping_original_x = 0;
chopping_original_y = 0;

// Variabili per sistema mining
is_mining = false;
mining_original_x = 0;
mining_original_y = 0;
mining_direction = "front";
chopping_direction = "front"; // Direzione salvata per l'animazione corrente
chop_cooldown = 0; // Cooldown dopo ogni chop

// Variabile per controllare harvest una pianta alla volta
global.harvest_this_frame = false;


sprite_index = spr_idle_front;
image_speed = 1;

// Depth rimosso - sarà impostato direttamente nell'editor

// Funzione per draw personalizzato (chiamata dal depth sorter)
function draw_player_with_clothes() {
    // Non disegnare il player se il menu è aperto
    if (instance_exists(obj_main_menu) && obj_main_menu.visible) {
        return; // Esce dalla funzione
    }

    // Disegna il player base
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

    // Sistema di rendering layered per i vestiti
    // Ordine: pantaloni → maglietta → capelli → cappello

    // Determina quale set di sprite usare in base alla direzione corrente
    var sprite_suffix = "";
    var should_draw_clothes = true;

    if (current_direction == "front" || current_direction == "idle") {
        sprite_suffix = "_front";
    } else if (current_direction == "back") {
        sprite_suffix = "_back";
    } else {
        // Per left/right non disegnare vestiti (non abbiamo sprite per queste direzioni)
        should_draw_clothes = false;
    }

    // Disegna pantaloni solo se dovremmo disegnare i vestiti
    if (should_draw_clothes && current_pants_index > 0 && current_pants_index < array_length(pants_sprites)) {
        var pants_sprite = noone;
        if (sprite_suffix == "_front") {
            pants_sprite = spr_pants_and_shoes_front;
        } else {
            pants_sprite = spr_pants_and_shoes_back;
        }
        
        if (pants_sprite != noone) {
            // Calcola posizione corretta considerando gli offset diversi
            var base_visual_x = x - sprite_get_xoffset(sprite_index);
            var base_visual_y = y - sprite_get_yoffset(sprite_index);
            var clothes_x = base_visual_x + sprite_get_xoffset(pants_sprite);
            var clothes_y = base_visual_y + sprite_get_yoffset(pants_sprite);
            
            draw_sprite_ext(pants_sprite, image_index, clothes_x, clothes_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
        }
    }

    // Disegna maglietta
    if (should_draw_clothes && current_shirt_index > 0 && current_shirt_index < array_length(shirt_sprites)) {
        var shirt_sprite = noone;
        if (sprite_suffix == "_front") {
            shirt_sprite = spr_shirt_front;
        } else {
            shirt_sprite = spr_shirt_back;
        }
        
        if (shirt_sprite != noone) {
            // Calcola posizione corretta considerando gli offset diversi
            var base_visual_x = x - sprite_get_xoffset(sprite_index);
            var base_visual_y = y - sprite_get_yoffset(sprite_index);
            var clothes_x = base_visual_x + sprite_get_xoffset(shirt_sprite);
            var clothes_y = base_visual_y + sprite_get_yoffset(shirt_sprite);
            
            draw_sprite_ext(shirt_sprite, image_index, clothes_x, clothes_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
        }
    }

    // Disegna capelli
    if (should_draw_clothes && current_hair_index > 0 && current_hair_index < array_length(hair_sprites)) {
        var hair_sprite = noone;
        if (sprite_suffix == "_front") {
            hair_sprite = spr_hair_front;
        } else {
            hair_sprite = spr_hair_back;
        }
        
        if (hair_sprite != noone) {
            // Calcola posizione corretta considerando gli offset diversi
            var base_visual_x = x - sprite_get_xoffset(sprite_index);
            var base_visual_y = y - sprite_get_yoffset(sprite_index);
            var clothes_x = base_visual_x + sprite_get_xoffset(hair_sprite);
            var clothes_y = base_visual_y + sprite_get_yoffset(hair_sprite);
            
            draw_sprite_ext(hair_sprite, image_index, clothes_x, clothes_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
        }
    }

    // Disegna cappello (sopra tutto)
    if (should_draw_clothes && current_hat_index > 0 && current_hat_index < array_length(hat_sprites)) {
        var hat_sprite = noone;
        if (sprite_suffix == "_front") {
            hat_sprite = spr_hat_front;
        } else {
            hat_sprite = spr_hat_back;
        }
        
        if (hat_sprite != noone) {
            // Calcola posizione corretta considerando gli offset diversi
            var base_visual_x = x - sprite_get_xoffset(sprite_index);
            var base_visual_y = y - sprite_get_yoffset(sprite_index);
            var clothes_x = base_visual_x + sprite_get_xoffset(hat_sprite);
            var clothes_y = base_visual_y + sprite_get_yoffset(hat_sprite);
            
            draw_sprite_ext(hat_sprite, image_index, clothes_x, clothes_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
        }
    }
}

// Cursore gestito da obj_cursor_manager

base_x = x;
base_y = y;

// Sistema vestiti - variabili per tenere traccia dell'abbigliamento attuale
current_hat_index = 0;     // 0 = nudo, 1 = primo vestito
current_hair_index = 0;    // 0 = nudo, 1 = primo vestito  
current_shirt_index = 1;   // 0 = nudo, 1 = primo vestito - ATTIVO per test
current_pants_index = 1;   // 0 = nudo, 1 = primo vestito - ATTIVO per test

// Array degli sprite dei vestiti (corrispondenti al dressing menu)
hat_sprites = [noone, spr_hat_front, spr_hat_back];
hair_sprites = [noone, spr_hair_front, spr_hair_back];
shirt_sprites = [noone, spr_shirt_front, spr_shirt_back];
pants_sprites = [noone, spr_pants_and_shoes_front, spr_pants_and_shoes_back];


// ===== AUTO-HIDE COLLISION LAYER IN GAME =====
var collision_layer = layer_get_id("Collision");
if (collision_layer != -1) {
    layer_set_visible(collision_layer, false);
    show_debug_message("🔍 Collision layer hidden for gameplay");
}

// ===== DEBUG COLLISION VISIBILITY =====
global.collision_debug_enabled = false;

function toggle_collision_debug() {
    var collision_layer = layer_get_id("Collision");
    if (collision_layer != -1) {
        var is_visible = layer_get_visible(collision_layer);
        layer_set_visible(collision_layer, !is_visible);
        global.collision_debug_enabled = !is_visible;
        show_debug_message("🔍 Collision debug: " + (is_visible ? "OFF" : "ON"));
    }
}

// Collision semplificata - SOLO obj_collision_block

// Funzione per determinare direzione verso il cursor
function get_direction_to_cursor() {
    var dx = mouse_x - x;
    var dy = mouse_y - y;
    
    // Determina direzione basata su angolo (rimuovo il controllo distanza che causava problemi)
    var angle = point_direction(x, y, mouse_x, mouse_y);
    var result = "";
    
    // Converti angolo in direzione cardinale
    // GameMaker usa 0° = destra, 90° = su, 180° = sinistra, 270° = giù
    if (angle >= 315 || angle < 45) {
        result = "right";
    } else if (angle >= 45 && angle < 135) {
        result = "back";  // Su nella vista top-down
    } else if (angle >= 135 && angle < 225) {
        result = "left";
    } else { // angle >= 225 && angle < 315
        result = "front"; // Giù nella vista top-down
    }
    
    // Debug per vedere cosa sta calcolando
    show_debug_message("🎯 Cursor direction: angle=" + string(angle) + "° → direction=" + result);
    return result;
}