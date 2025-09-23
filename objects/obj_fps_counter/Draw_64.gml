// FPS Counter Display - GUI Layer (sempre visibile)

// Update FPS ogni 10 frame per stabilità
update_timer++;
if (update_timer >= 10) {
    fps_current = fps_real;

    // Mantieni storia degli ultimi 5 valori per smoothing
    array_push(fps_history, fps_current);
    if (array_length(fps_history) > 5) {
        array_delete(fps_history, 0, 1);
    }

    // Calcola FPS smooth
    var total = 0;
    for (var i = 0; i < array_length(fps_history); i++) {
        total += fps_history[i];
    }
    fps_smooth = total / array_length(fps_history);

    update_timer = 0;
}

// Determina colore basato su performance
if (fps_smooth >= fps_good) {
    fps_color = c_lime;        // Verde - Buono
} else if (fps_smooth >= fps_warning) {
    fps_color = c_yellow;      // Giallo - Warning
} else if (fps_smooth >= fps_critical) {
    fps_color = c_orange;      // Arancione - Problema
} else {
    fps_color = c_red;         // Rosso - Critico
}

// Display FPS solo - nessun background
draw_set_color(fps_color);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Testo FPS principale
var fps_text = "FPS: " + string_format(fps_smooth, 0, 1);
draw_fps_text(fps_x, fps_y, fps_text);

// Reset draw settings
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);