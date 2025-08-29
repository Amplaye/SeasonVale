
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