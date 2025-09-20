// === TRANSITION DEBUG VISUALIZATION ===
// Debug visualization per transition blocks
if (global.collision_debug_enabled) {
    // Disegna transition area
    draw_set_color(c_green);
    draw_set_alpha(0.5);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);

    // Outline
    draw_set_alpha(1.0);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);

    // Se abbiamo una direzione specifica, disegna una freccia
    if (requiredDirection != "any") {
        var arrow_x = x + sprite_width/2;
        var arrow_y = y + sprite_height/2;
        var arrow_size = 8;

        draw_set_color(c_yellow);

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
    }

    // Debug text
    draw_set_color(c_white);
    draw_text(x, y - 20, "Dir: " + requiredDirection);

    // Reset drawing properties
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}