// Dialogue Manager - Handles all conversation systems

depth = -6000; // Dialogue manager - layer Meta

// Dialogue state variables
dialogue_active = false;
dialogue_text = "";
dialogue_speaker = "";
dialogue_current_line = 0;
dialogue_lines = [];
dialogue_npc = noone;

// UI variables
dialogue_box_x = 50;
dialogue_box_y = display_get_gui_height() - 150;
dialogue_box_width = display_get_gui_width() - 100;
dialogue_box_height = 120;

// Text display variables
dialogue_char_timer = 0;
dialogue_char_speed = 2; // Characters per frame
dialogue_chars_displayed = 0;
dialogue_text_complete = false;

// Choice system variables
dialogue_choices = [];
dialogue_choice_selected = 0;
dialogue_has_choices = false;

// Initialize dialogue database
if (!variable_global_exists("dialogue_data_loaded")) {
    dialogue_load_database();
    global.dialogue_data_loaded = true;
}

show_debug_message("Dialogue Manager initialized");