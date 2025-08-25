if (target != noone && instance_exists(target)) {
    var visual_x = target.x - sprite_get_xoffset(target.sprite_index) + sprite_get_width(target.sprite_index)/2;
    var visual_y = target.y - sprite_get_yoffset(target.sprite_index) + sprite_get_height(target.sprite_index)/2;
    
    camera_set_view_pos(cam, visual_x - view_w/2, visual_y - view_h/2);
} else {
    var player = instance_find(obj_player, 0);
    if (player != noone) {
        target = player;
    }
}