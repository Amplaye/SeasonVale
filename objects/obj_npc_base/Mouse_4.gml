// NPC Base - Left Mouse Click Interaction

// Check if player is close enough to talk
if (npc_can_talk && !global.dialogue_in_progress) {
    var distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);

    if (distance_to_player <= npc_talk_range) {
        // Start dialogue with this NPC
        if (variable_struct_exists(npc_data, "dialogue_id")) {
            dialogue_start(npc_data.dialogue_id, id);
        } else {
            // Default dialogue
            dialogue_start("default_greeting", id);
        }
    }
}