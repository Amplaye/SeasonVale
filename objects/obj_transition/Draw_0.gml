// === TRANSITION VISUAL INDICATOR ===

// Disegna lo sprite base
draw_self();

// Se abbiamo una direzione specifica, disegna una freccia
if (requiredDirection != "any") {
    var arrow_x = x + sprite_width/2;
    var arrow_y = y + sprite_height/2;
    var arrow_size = 8;

    // Colore della freccia basato sulla direzione
    var arrow_color = c_yellow;

    draw_set_color(arrow_color);

    // Disegna freccia basata sulla direzione richiesta
    switch(requiredDirection) {
        case "up":
            draw_triangle(arrow_x, arrow_y - arrow_size,
                         arrow_x - arrow_size/2, arrow_y + arrow_size/2,
                         arrow_x + arrow_size/2, arrow_y + arrow_size/2, false);
            break;

        case "down":
            draw_triangle(arrow_x, arrow_y + arrow_size,
                         arrow_x - arrow_size/2, arrow_y - arrow_size/2,
                         arrow_x + arrow_size/2, arrow_y - arrow_size/2, false);
            break;

        case "left":
            draw_triangle(arrow_x - arrow_size, arrow_y,
                         arrow_x + arrow_size/2, arrow_y - arrow_size/2,
                         arrow_x + arrow_size/2, arrow_y + arrow_size/2, false);
            break;

        case "right":
            draw_triangle(arrow_x + arrow_size, arrow_y,
                         arrow_x - arrow_size/2, arrow_y - arrow_size/2,
                         arrow_x - arrow_size/2, arrow_y + arrow_size/2, false);
            break;
    }

    // Reset colore
    draw_set_color(c_white);
}

// Debug text (solo durante lo sviluppo)
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    draw_set_color(c_white);
    draw_text(x, y - 20, "Dir: " + requiredDirection);
    draw_set_color(c_white);
}