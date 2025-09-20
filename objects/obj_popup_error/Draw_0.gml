// ===================================================================
// 🚨 POPUP ERROR - DISEGNO TESTO
// ===================================================================

// Disegna prima lo sprite del popup
draw_self();

// Se visibile, disegna il testo sopra
if (visible && global.popup_active) {
    // Calcola posizione centrale del popup
    var text_x = x + sprite_width / 2;
    var text_y = y + sprite_height / 2;
    
    // Imposta stile testo
    draw_set_color(c_black);
    draw_set_font(main_font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Usa font normale ma scalato con padding per evitare tagli
    var text_scale = 0.24;
    var padding = 1; // Padding extra per evitare tagli
    
    draw_text_transformed(text_x, text_y + padding, popup_title, text_scale, text_scale, 0);
    
    // Reset impostazioni draw
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}