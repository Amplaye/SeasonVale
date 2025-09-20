// Disegna la pianta normalmente
draw_self();

// Se evidenziata e pronta per harvest, mostra indicatore
if (variable_instance_exists(id, "is_highlighted") && is_highlighted && can_harvest && harvest_cooldown <= 0) {
    // Cerchio giallo pulsante intorno alla pianta
    var pulse = sin(current_time * 0.01) * 0.3 + 0.7; // Pulsazione da 0.4 a 1.0
    var circle_radius = 24 + sin(current_time * 0.008) * 4; // Raggio che oscilla

    // Disegna cerchio di highlight
    draw_set_color(make_color_rgb(255, 255, 100));
    draw_set_alpha(pulse * 0.5);
    draw_circle(x, y, circle_radius, false);

    // Testo indicatore
    draw_set_alpha(pulse);
    draw_set_font(main_font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);

    // Ombra del testo
    draw_text(x + 1, y - sprite_height/2 - 9, "RMB");

    // Testo principale
    draw_set_color(c_yellow);
    draw_text(x, y - sprite_height/2 - 10, "RMB");

    // Reset impostazioni draw
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}