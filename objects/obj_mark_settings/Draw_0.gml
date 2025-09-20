if (visible) {
    // Calcola posizione relativa al centro della view (come il main menu)
    var cam = view_camera[0];
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);

    var center_x = view_x + view_w / 2;
    var center_y = view_y + view_h / 2;

    // Offset relativo al menu centrato
    var offset_x = -24;
    var offset_y = -78;

    // Calcola posizione finale del mark
    var mark_x = center_x + offset_x;
    var mark_y = center_y + offset_y;

    // Aggiorna posizione per i click
    x = mark_x;
    y = mark_y;

    // Disegna il mark nella posizione relativa al menu
    draw_sprite_ext(spr_mark, image_index, mark_x, mark_y, image_xscale, image_yscale, image_angle, image_blend, 1);
}