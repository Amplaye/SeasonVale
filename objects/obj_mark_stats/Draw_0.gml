if (visible) {
    // Calcola posizione relativa al centro della view
    var cam = view_camera[0];
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);
    
    var center_x = view_x + view_w / 2;
    var center_y = view_y + view_h / 2;
    
    // Offset dal centro del menu (originalmente 152-240, 59-137)
    var offset_x = -88;
    var offset_y = -78;
    
    // Aggiorna la posizione dell'oggetto per i click
    x = center_x + offset_x;
    y = center_y + offset_y;
    
    // Disegna il mark nella posizione corretta
    draw_sprite_ext(mark, image_index, x, y, 1, 1, 0, c_white, 1);
}