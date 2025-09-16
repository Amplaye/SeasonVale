// Dialogue System - Functions for managing conversations

// Initialize dialogue database
function dialogue_load_database() {
    global.dialogue_database = {
        "farmer_intro": {
            "speaker": "Old Tom",
            "lines": [
                "Hello there, young one! Welcome to our humble village.",
                "I've been farming these lands for over 40 years.",
                "If you need any tips about growing crops, just ask!"
            ],
            "choices": []
        },
        "merchant_intro": {
            "speaker": "Trader Joe",
            "lines": [
                "Greetings, traveler! Looking for some quality goods?",
                "I've got the finest tools and seeds in the valley."
            ],
            "choices": [
                {
                    "text": "Show me your wares",
                    "action": "open_shop"
                },
                {
                    "text": "Maybe later",
                    "action": "end_dialogue"
                }
            ]
        },
        "villager_intro": {
            "speaker": "Sarah",
            "lines": [
                "Oh, hello! It's so nice to see a new face around here.",
                "This valley has been quite peaceful lately.",
                "I hope you enjoy your stay!"
            ],
            "choices": []
        },
        "default_greeting": {
            "speaker": "Villager",
            "lines": [
                "Hello there!",
                "Nice weather we're having, isn't it?"
            ],
            "choices": []
        }
    };
}

// Start a dialogue with specified ID and NPC
function dialogue_start(dialogue_id, npc_instance) {
    // Create dialogue manager if it doesn't exist
    if (!instance_exists(obj_dialogue_manager)) {
        instance_create_layer(0, 0, layer, obj_dialogue_manager);
    }

    var dialogue_manager = obj_dialogue_manager;

    // Get dialogue data
    if (!variable_struct_exists(global.dialogue_database, dialogue_id)) {
        show_debug_message("Dialogue ID not found: " + string(dialogue_id));
        return false;
    }

    var dialogue_data = global.dialogue_database[$ dialogue_id];

    // Set up dialogue
    with (dialogue_manager) {
        dialogue_active = true;
        dialogue_speaker = dialogue_data.speaker;
        dialogue_lines = dialogue_data.lines;
        dialogue_choices = dialogue_data.choices;
        dialogue_current_line = 0;
        dialogue_npc = npc_instance;

        // Set up first line
        dialogue_set_line(0);
    }

    // Update global state
    global.dialogue_in_progress = true;

    // Set NPC talking state
    if (instance_exists(npc_instance)) {
        npc_instance.npc_is_talking = true;
    }

    return true;
}

// Set a specific dialogue line
function dialogue_set_line(line_index) {
    if (line_index < array_length(dialogue_lines)) {
        dialogue_text = dialogue_lines[line_index];
        dialogue_current_line = line_index;
        dialogue_chars_displayed = 0;
        dialogue_text_complete = false;
        dialogue_char_timer = 0;

        // Check if this is the last line and has choices
        if (line_index == array_length(dialogue_lines) - 1 && array_length(dialogue_choices) > 0) {
            dialogue_has_choices = true;
            dialogue_choice_selected = 0;
        } else {
            dialogue_has_choices = false;
        }
    }
}

// Continue to next dialogue line or end dialogue
function dialogue_continue() {
    var next_line = dialogue_current_line + 1;

    if (next_line < array_length(dialogue_lines)) {
        // Move to next line
        dialogue_set_line(next_line);
    } else {
        // End dialogue
        dialogue_end();
    }
}

// Execute a dialogue choice
function dialogue_execute_choice(choice) {
    switch (choice.action) {
        case "end_dialogue":
            dialogue_end();
            break;

        case "open_shop":
            dialogue_end();
            // TODO: Open shop interface
            show_debug_message("Opening shop...");
            break;

        case "start_quest":
            // TODO: Start quest system integration
            show_debug_message("Starting quest: " + string(choice.quest_id ?? "unknown"));
            dialogue_end();
            break;

        default:
            dialogue_end();
            break;
    }
}

// End the current dialogue
function dialogue_end() {
    dialogue_active = false;
    global.dialogue_in_progress = false;

    // Reset NPC talking state
    if (instance_exists(dialogue_npc)) {
        dialogue_npc.npc_is_talking = false;
    }

    dialogue_npc = noone;
    dialogue_lines = [];
    dialogue_choices = [];
    dialogue_has_choices = false;

    show_debug_message("Dialogue ended");
}

// Check if dialogue system is active
function dialogue_is_active() {
    return global.dialogue_in_progress;
}

// Add a new dialogue to the database (for quest system)
function dialogue_add_to_database(dialogue_id, speaker, lines, choices) {
    global.dialogue_database[$ dialogue_id] = {
        "speaker": speaker,
        "lines": lines,
        "choices": choices ?? []
    };
}