// Dialogue Manager GUI Draw - UI rendering

if (dialogue_active) {
    // Calcola posizione dinamicamente per supportare cambio risoluzione
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    dialogue_box_x = 50;
    dialogue_box_y = gui_h - 150;
    dialogue_box_width = gui_w - 100;
    dialogue_box_height = 120;
    // Draw dialogue box background
    draw_set_color(c_gray);
    draw_set_alpha(0.8);
    draw_rectangle(dialogue_box_x, dialogue_box_y,
                   dialogue_box_x + dialogue_box_width,
                   dialogue_box_y + dialogue_box_height, false);

    // Draw dialogue box border
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_rectangle(dialogue_box_x, dialogue_box_y,
                   dialogue_box_x + dialogue_box_width,
                   dialogue_box_y + dialogue_box_height, true);

    // Draw speaker name
    draw_set_color(c_yellow);
    draw_dialogue_text(dialogue_box_x + 10, dialogue_box_y + 5, dialogue_speaker);

    // Draw dialogue text with typewriter effect
    draw_set_color(c_white);
    var displayed_text = string_copy(dialogue_text, 1, dialogue_chars_displayed);
    draw_dialogue_text_ext(dialogue_box_x + 10, dialogue_box_y + 25,
                  displayed_text, 16, dialogue_box_width - 20);

    // Draw continue prompt or choices
    if (dialogue_text_complete) {
        if (dialogue_has_choices) {
            // Draw choices
            draw_set_color(c_ltgray);
            draw_dialogue_text(dialogue_box_x + 10, dialogue_box_y + 80, "Choose:");

            for (var i = 0; i < array_length(dialogue_choices); i++) {
                var choice_color = (i == dialogue_choice_selected) ? c_yellow : c_white;
                draw_set_color(choice_color);
                draw_dialogue_text(dialogue_box_x + 20, dialogue_box_y + 95 + (i * 15),
                          "• " + dialogue_choices[i].text);
            }
        } else {
            // Draw continue prompt
            draw_set_color(c_ltgray);
            draw_dialogue_text(dialogue_box_x + dialogue_box_width - 120,
                      dialogue_box_y + dialogue_box_height - 20,
                      "Press SPACE to continue");
        }
    }
}