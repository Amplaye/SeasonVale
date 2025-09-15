// Debug collision visualization - solo player bbox
if (global.collision_debug_enabled) {
    // Disegna la collision box del player
    draw_set_color(c_red);
    draw_set_alpha(0.4);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);

    // Outline
    draw_set_alpha(0.8);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);

    // Centro player
    draw_set_color(c_red);
    draw_set_alpha(1.0);
    draw_circle(x, y, 1, false);

    // Reset properties
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}