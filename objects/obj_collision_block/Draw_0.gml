// Debug visualization per collision blocks
if (global.collision_debug_enabled) {
    // Disegna collision block
    draw_set_color(c_blue);
    draw_set_alpha(0.5);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);

    // Outline
    draw_set_alpha(1.0);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);

    // Reset drawing properties
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}