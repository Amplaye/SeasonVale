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

    // Handle choice navigation
    if (dialogue_has_choices && dialogue_text_complete) {
        var choice_count = array_length(dialogue_choices);

        if (keyboard_check_pressed(vk_up)) {
            dialogue_choice_selected--;
            if (dialogue_choice_selected < 0) {
                dialogue_choice_selected = choice_count - 1;
            }
        }

        if (keyboard_check_pressed(vk_down)) {
            dialogue_choice_selected++;
            if (dialogue_choice_selected >= choice_count) {
                dialogue_choice_selected = 0;
            }
        }
    }
}