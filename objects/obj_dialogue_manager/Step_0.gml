// Dialogue Manager Step - Handle dialogue progression

if (dialogue_active) {
    // Update text typewriter effect
    if (!dialogue_text_complete) {
        dialogue_char_timer++;

        if (dialogue_char_timer >= dialogue_char_speed) {
            dialogue_char_timer = 0;
            dialogue_chars_displayed++;

            if (dialogue_chars_displayed >= string_length(dialogue_text)) {
                dialogue_text_complete = true;
            }
        }
    }

    // Handle input for dialogue progression
    if (dialogue_text_complete) {
        // Check for left mouse click or spacebar
        var input_pressed = keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left);

        if (input_pressed) {
            if (dialogue_has_choices) {
                // Execute selected choice
                var selected_choice = dialogue_choices[dialogue_choice_selected];
                dialogue_execute_choice(selected_choice);
            } else {
                // Continue to next dialogue line
                dialogue_continue();
            }
        }
    } else {
        // Skip typewriter effect with spacebar or left click
        var skip_input = keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left);
        if (skip_input) {
            dialogue_chars_displayed = string_length(dialogue_text);
            dialogue_text_complete = true;
        }
    }

    // Handle choice navigation
    if (dialogue_has_choices && dialogue_text_complete) {
        var choice_count = array_length(dialogue_choices);

        if (keyboard_check_pressed(ord("W"))) {
            dialogue_choice_selected--;
            if (dialogue_choice_selected < 0) {
                dialogue_choice_selected = choice_count - 1;
            }
        }

        if (keyboard_check_pressed(ord("S"))) {
            dialogue_choice_selected++;
            if (dialogue_choice_selected >= choice_count) {
                dialogue_choice_selected = 0;
            }
        }
    }
}