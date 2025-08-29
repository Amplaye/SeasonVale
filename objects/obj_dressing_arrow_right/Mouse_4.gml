if (visible && obj_dressing_menu.visible) {
    var menu = obj_dressing_menu;
    
    switch (menu.current_category) {
        case "hat":
            menu.current_hat_index++;
            if (menu.current_hat_index >= array_length(menu.hat_sprites)) {
                menu.current_hat_index = 0;
            }
            break;
        case "hair":
            menu.current_hair_index++;
            if (menu.current_hair_index >= array_length(menu.hair_sprites)) {
                menu.current_hair_index = 0;
            }
            break;
        case "shirt":
            menu.current_shirt_index++;
            if (menu.current_shirt_index >= array_length(menu.shirt_sprites)) {
                menu.current_shirt_index = 0;
            }
            break;
        case "pants":
            menu.current_pants_index++;
            if (menu.current_pants_index >= array_length(menu.pants_sprites)) {
                menu.current_pants_index = 0;
            }
            break;
    }
}