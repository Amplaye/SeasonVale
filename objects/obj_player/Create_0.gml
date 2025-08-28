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

// Variabili per sistema chopping
is_chopping = false;
chopping_original_x = 0;
chopping_original_y = 0;


sprite_index = idle_front;
image_speed = 1;

// Cursore gestito da obj_cursor_manager

base_x = x;
base_y = y;