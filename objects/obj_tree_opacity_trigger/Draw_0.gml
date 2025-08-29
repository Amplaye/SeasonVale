// Debug: mostra area trigger (rimuovere in produzione)
draw_set_alpha(0.2);
draw_set_color(c_yellow);
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
draw_set_alpha(1);
draw_set_color(c_white);