// Non disegnare il player se il menu è aperto
if (instance_exists(obj_main_menu) && obj_main_menu.visible) {
    return; // Esce dal Draw event
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
        pants_sprite = pants_and_shoes_front;
    } else {
        pants_sprite = pants_and_shoes_back;
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
        shirt_sprite = shirt_front;
    } else {
        shirt_sprite = shirt_back;
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
        hair_sprite = hair_front;
    } else {
        hair_sprite = hair_back;
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
        hat_sprite = hat_front;
    } else {
        hat_sprite = hat_back;
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