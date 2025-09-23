// Overlay giorno/notte su tutta la view
if (overlay_alpha > 0) {
    draw_set_alpha(overlay_alpha);
    draw_set_color(overlay_color);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// HUD tempo in alto a destra
var gui_w = display_get_gui_width();
var time_text = "Day " + string(global.game_day) + " - " + format_time();

draw_set_halign(fa_right);
draw_set_valign(fa_top);

// Ombra testo
draw_set_color(c_black);
draw_time_hud_text(gui_w - 9, 9, time_text);

// Testo principale
draw_set_color(c_white);
draw_time_hud_text(gui_w - 10, 10, time_text);

// Reset draw settings  
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// CONTROLLI TEMPO TEMPORANEI (da rimuovere dopo test)
var controls_text = "TIME CONTROLS (TEST):\nF = Skip Day | U = +1 Hour | Y = +30min";
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Ombra
draw_set_color(c_black);
draw_time_hud_text(11, 51, controls_text);

// Testo principale
draw_set_color(c_white);
draw_time_hud_text(10, 50, controls_text);

// Reset
draw_set_color(c_white);