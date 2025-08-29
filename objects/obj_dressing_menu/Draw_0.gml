if (visible) {
    // Usa lo scaling dell'editor
    draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    
    // Aggiungi testo per categoria e controlli
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Testo categoria attuale
    var text_x = x;
    var text_y = y - 60 * image_yscale;
    draw_text_transformed(text_x, text_y, string_upper(current_category), image_xscale, image_yscale, 0);
    
    // Istruzioni
    var instr_y = y + 80 * image_yscale;
    draw_text_transformed(text_x, instr_y, "FRECCE SU/GIU: Categoria", image_xscale * 0.8, image_yscale * 0.8, 0);
    instr_y += 20 * image_yscale;
    draw_text_transformed(text_x, instr_y, "CLICK FRECCE: Vestito", image_xscale * 0.8, image_yscale * 0.8, 0);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}