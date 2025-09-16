// Quest System - Functions for managing quests and objectives

// Initialize quest database
function quest_load_database() {
    global.quest_database = {
        "first_harvest": {
            "name": "First Harvest",
            "description": "Plant and harvest your first crop to start your farming journey.",
            "giver": "farmer",
            "objectives": [
                {
                    "type": "plant_crop",
                    "target": "any",
                    "count": 1,
                    "current": 0,
                    "description": "Plant a crop"
                },
                {
                    "type": "harvest_crop",
                    "target": "any",
                    "count": 1,
                    "current": 0,
                    "description": "Harvest the crop"
                }
            ],
            "rewards": {
                "gold": 50,
                "items": ["seeds_tomato", "seeds_carrot"],
                "experience": 100
            }
        },
        "meet_villagers": {
            "name": "Welcome to the Valley",
            "description": "Introduce yourself to the friendly villagers.",
            "giver": "villager",
            "objectives": [
                {
                    "type": "talk_to_npc",
                    "target": "farmer",
                    "count": 1,
                    "current": 0,
                    "description": "Talk to Old Tom the farmer"
                },
                {
                    "type": "talk_to_npc",
                    "target": "merchant",
                    "count": 1,
                    "current": 0,
                    "description": "Talk to Trader Joe"
                }
            ],
            "rewards": {
                "gold": 25,
                "items": ["tool_basic_hoe"],
                "experience": 50
            }
        },
        "gather_resources": {
            "name": "Resource Gathering",
            "description": "Collect basic materials for your farm.",
            "giver": "merchant",
            "objectives": [
                {
                    "type": "collect_item",
                    "target": "wood",
                    "count": 10,
                    "current": 0,
                    "description": "Collect 10 pieces of wood"
                },
                {
                    "type": "collect_item",
                    "target": "stone",
                    "count": 5,
                    "current": 0,
                    "description": "Collect 5 stones"
                }
            ],
            "rewards": {
                "gold": 75,
                "items": ["tool_basic_axe"],
                "experience": 75
            }
        }
    };
}

// Start a new quest
function quest_start(quest_id) {
    // Check if quest exists
    if (!variable_struct_exists(global.quest_database, quest_id)) {
        show_debug_message("Quest not found: " + string(quest_id));
        return false;
    }

    // Check if already active or completed
    if (ds_map_exists(global.active_quests, quest_id)) {
        show_debug_message("Quest already active: " + string(quest_id));
        return false;
    }

    if (ds_list_find_index(global.completed_quests, quest_id) != -1) {
        show_debug_message("Quest already completed: " + string(quest_id));
        return false;
    }

    // Get quest data and create active quest instance
    var quest_data = global.quest_database[$ quest_id];
    var active_quest = {
        "id": quest_id,
        "name": quest_data.name,
        "description": quest_data.description,
        "giver": quest_data.giver,
        "objectives": [],
        "rewards": quest_data.rewards,
        "start_time": get_timer()
    };

    // Copy objectives with current progress
    for (var i = 0; i < array_length(quest_data.objectives); i++) {
        var obj = quest_data.objectives[i];
        array_push(active_quest.objectives, {
            "type": obj.type,
            "target": obj.target,
            "count": obj.count,
            "current": 0,
            "description": obj.description,
            "completed": false
        });
    }

    // Add to active quests
    ds_map_add(global.active_quests, quest_id, active_quest);

    show_debug_message("Quest started: " + active_quest.name);
    return true;
}

// Update quest progress
function quest_update_progress(quest_type, target, amount) {
    var quest_key = ds_map_find_first(global.active_quests);
    var updated_quests = [];

    while (!is_undefined(quest_key)) {
        var quest = ds_map_find_value(global.active_quests, quest_key);

        // Check each objective
        for (var i = 0; i < array_length(quest.objectives); i++) {
            var obj = quest.objectives[i];

            if (!obj.completed && obj.type == quest_type) {
                if (obj.target == "any" || obj.target == target) {
                    obj.current = min(obj.current + amount, obj.count);

                    if (obj.current >= obj.count) {
                        obj.completed = true;
                        show_debug_message("Objective completed: " + obj.description);
                    }
                }
            }
        }

        // Check if quest is complete
        if (quest_is_complete(quest)) {
            array_push(updated_quests, quest_key);
        }

        quest_key = ds_map_find_next(global.active_quests, quest_key);
    }

    // Complete any finished quests
    for (var i = 0; i < array_length(updated_quests); i++) {
        quest_complete(updated_quests[i]);
    }
}

// Check if a quest is complete
function quest_is_complete(quest) {
    for (var i = 0; i < array_length(quest.objectives); i++) {
        if (!quest.objectives[i].completed) {
            return false;
        }
    }
    return true;
}

// Complete a quest
function quest_complete(quest_id) {
    if (!ds_map_exists(global.active_quests, quest_id)) {
        return false;
    }

    var quest = ds_map_find_value(global.active_quests, quest_id);

    // Give rewards
    quest_give_rewards(quest.rewards);

    // Move to completed quests
    ds_list_add(global.completed_quests, quest_id);
    ds_map_delete(global.active_quests, quest_id);

    show_debug_message("Quest completed: " + quest.name);

    // TODO: Show completion UI/notification
    return true;
}

// Give quest rewards to player
function quest_give_rewards(rewards) {
    // Give gold
    if (variable_struct_exists(rewards, "gold")) {
        // TODO: Add to player gold
        show_debug_message("Received " + string(rewards.gold) + " gold!");
    }

    // Give items
    if (variable_struct_exists(rewards, "items")) {
        for (var i = 0; i < array_length(rewards.items); i++) {
            // TODO: Add to player inventory
            show_debug_message("Received item: " + rewards.items[i]);
        }
    }

    // Give experience
    if (variable_struct_exists(rewards, "experience")) {
        // TODO: Add to player experience
        show_debug_message("Received " + string(rewards.experience) + " experience!");
    }
}

// Check all active quest progress
function quest_check_all_progress() {
    // This function can be used to check for automatic quest updates
    // For example, checking inventory changes, player stats, etc.

    // Example: Check if player has items for collection quests
    var quest_key = ds_map_find_first(global.active_quests);

    while (!is_undefined(quest_key)) {
        var quest = ds_map_find_value(global.active_quests, quest_key);

        // Auto-update collection objectives based on inventory
        // TODO: Integrate with inventory system when available

        quest_key = ds_map_find_next(global.active_quests, quest_key);
    }
}

// Get active quest list
function quest_get_active() {
    var quest_list = [];
    var quest_key = ds_map_find_first(global.active_quests);

    while (!is_undefined(quest_key)) {
        var quest = ds_map_find_value(global.active_quests, quest_key);
        array_push(quest_list, quest);
        quest_key = ds_map_find_next(global.active_quests, quest_key);
    }

    return quest_list;
}

// Get quest by ID
function quest_get_by_id(quest_id) {
    if (ds_map_exists(global.active_quests, quest_id)) {
        return ds_map_find_value(global.active_quests, quest_id);
    }
    return undefined;
}

// Check if quest is available to start
function quest_is_available(quest_id) {
    return !ds_map_exists(global.active_quests, quest_id) &&
           ds_list_find_index(global.completed_quests, quest_id) == -1;
}