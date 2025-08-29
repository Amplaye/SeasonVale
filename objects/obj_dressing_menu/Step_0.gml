if (keyboard_check_pressed(vk_escape)) {
    visible = !visible;
    show_debug_message("ESC pressed! Menu visible: " + string(visible));
    
    if (visible) {
        if (instance_exists(obj_player)) {
            obj_player.can_move = false;
        }
        
        if (instance_exists(obj_dressing_arrow_left)) {
            obj_dressing_arrow_left.visible = true;
        }
        if (instance_exists(obj_dressing_arrow_right)) {
            obj_dressing_arrow_right.visible = true;
        }
        if (instance_exists(obj_dressing_player_preview)) {
            obj_dressing_player_preview.visible = true;
        }
    } else {
        if (instance_exists(obj_player)) {
            obj_player.can_move = true;
        }
        
        if (instance_exists(obj_dressing_arrow_left)) {
            obj_dressing_arrow_left.visible = false;
        }
        if (instance_exists(obj_dressing_arrow_right)) {
            obj_dressing_arrow_right.visible = false;
        }
        if (instance_exists(obj_dressing_player_preview)) {
            obj_dressing_player_preview.visible = false;
        }
    }
}

if (visible) {
    if (keyboard_check_pressed(vk_up)) {
        category_index--;
        if (category_index < 0) {
            category_index = array_length(categories) - 1;
        }
        current_category = categories[category_index];
    }
    
    if (keyboard_check_pressed(vk_down)) {
        category_index++;
        if (category_index >= array_length(categories)) {
            category_index = 0;
        }
        current_category = categories[category_index];
    }
}