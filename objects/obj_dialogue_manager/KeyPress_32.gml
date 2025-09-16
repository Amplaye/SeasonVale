// Dialogue Manager - SPACE key press handling

if (dialogue_active) {
    if (!dialogue_text_complete) {
        // Skip typewriter effect - show all text immediately
        dialogue_chars_displayed = string_length(dialogue_text);
        dialogue_text_complete = true;
    } else {
        if (dialogue_has_choices) {
            // Execute selected choice
            var selected_choice = dialogue_choices[dialogue_choice_selected];
            dialogue_execute_choice(selected_choice);
        } else {
            // Continue to next dialogue line
            dialogue_continue();
        }
    }
}