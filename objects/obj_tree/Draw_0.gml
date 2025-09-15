// Disegna l'albero con effetto shake visivo
if (shake_timer > 0) {
    // Calcola offset shake solo per il rendering
    var shake_x = cos(shake_direction) * shake_intensity;
    var shake_y = sin(shake_direction) * shake_intensity;

    // Disegna sprite con offset shake mantenendo alpha
    draw_sprite_ext(sprite_index, image_index, x + shake_x, y + shake_y, 1, 1, 0, c_white, image_alpha);
} else {
    // Disegna normalmente con alpha corrente
    draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, image_alpha);
}

// Debug rimosso - alberi non hanno più collision