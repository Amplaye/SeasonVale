visible = false;
depth = -1000;

// Sincronizza con lo stato del player se esiste
if (instance_exists(obj_player)) {
    current_hat_index = obj_player.current_hat_index;
    current_hair_index = obj_player.current_hair_index;
    current_shirt_index = obj_player.current_shirt_index;
    current_pants_index = obj_player.current_pants_index;
} else {
    current_hat_index = 1;
    current_hair_index = 1;
    current_shirt_index = 1;
    current_pants_index = 1;
}

hat_sprites = [noone, spr_hat_front];
hair_sprites = [noone, spr_hair_front];
shirt_sprites = [noone, spr_shirt_front];
pants_sprites = [noone, spr_pants_and_shoes_front];

current_category = "hat";
categories = ["hat", "hair", "shirt", "pants"];
category_index = 0;