cam = view_camera[0];
target = noone;

camera_speed = 0.8;

view_w = 480;
view_h = 270;

var player = instance_find(obj_player, 0);
if (player != noone) {
    target = player;
    x = target.x;
    y = target.y;
}

camera_set_view_pos(cam, x - view_w/2, y - view_h/2);