if (instance_number(obj_player) > 1) {
    instance_destroy();
    exit;
}

speed_walk = 2;
speed_run = 4;

hsp = 0;
vsp = 0;

current_direction = "idle";
is_moving = false;

sprite_index = idle_front;
image_speed = 1;

base_x = x;
base_y = y;