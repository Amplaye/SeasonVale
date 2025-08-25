var left = keyboard_check(ord("A")) || keyboard_check(vk_left);
var right = keyboard_check(ord("D")) || keyboard_check(vk_right);
var up = keyboard_check(ord("W")) || keyboard_check(vk_up);
var down = keyboard_check(ord("S")) || keyboard_check(vk_down);
var run = keyboard_check(vk_shift);

var move_speed = run ? speed_run : speed_walk;

hsp = 0;
vsp = 0;

if (left && !right) {
    hsp = -1;
}
if (right && !left) {
    hsp = 1;
}
if (up && !down) {
    vsp = -1;
}
if (down && !up) {
    vsp = 1;
}

if (hsp != 0 || vsp != 0) {
    var length = sqrt(hsp * hsp + vsp * vsp);
    hsp = (hsp / length) * move_speed;
    vsp = (vsp / length) * move_speed;
}

is_moving = (hsp != 0) || (vsp != 0);

if (is_moving) {
    x += hsp;
    y += vsp;
    
    var new_sprite = -1;
    var new_direction = "";
    
    if (hsp != 0 && vsp != 0) {
        if (current_direction == "right" || current_direction == "left") {
            if (abs(hsp) >= abs(vsp) * 0.7) {
                if (hsp > 0) {
                    new_direction = "right";
                    new_sprite = run_right;
                }
                else {
                    new_direction = "left";
                    new_sprite = run_left;
                }
            } else {
                if (vsp > 0) {
                    new_direction = "front";
                    new_sprite = run_front;
                }
                else {
                    new_direction = "back";
                    new_sprite = run_back;
                }
            }
        } else {
            if (abs(vsp) >= abs(hsp) * 0.7) {
                if (vsp > 0) {
                    new_direction = "front";
                    new_sprite = run_front;
                }
                else {
                    new_direction = "back";
                    new_sprite = run_back;
                }
            } else {
                if (hsp > 0) {
                    new_direction = "right";
                    new_sprite = run_right;
                }
                else {
                    new_direction = "left";
                    new_sprite = run_left;
                }
            }
        }
    }
    else if (hsp > 0) {
        new_direction = "right";
        new_sprite = run_right;
    }
    else if (hsp < 0) {
        new_direction = "left";
        new_sprite = run_left;
    }
    else if (vsp > 0) {
        new_direction = "front";
        new_sprite = run_front;
    }
    else if (vsp < 0) {
        new_direction = "back";
        new_sprite = run_back;
    }
    
    if (new_sprite != -1) {
        current_direction = new_direction;
        if (sprite_index != new_sprite) {
            var old_frame = image_index;
            var old_speed = image_speed;
            var old_sprite = sprite_index;
            
            var old_visual_x = x - sprite_get_xoffset(old_sprite);
            var old_visual_y = y - sprite_get_yoffset(old_sprite);
            
            sprite_index = new_sprite;
            
            x = old_visual_x + sprite_get_xoffset(new_sprite);
            y = old_visual_y + sprite_get_yoffset(new_sprite);
            
            if (sprite_get_number(sprite_index) > 0) {
                var frame_ratio = old_frame / max(sprite_get_number(sprite_index), 1);
                image_index = frame_ratio * sprite_get_number(sprite_index);
                image_index = clamp(image_index, 0, sprite_get_number(sprite_index) - 1);
            }
            image_speed = old_speed;
        }
    }
} else {
    var new_sprite = -1;
    
    switch(current_direction) {
        case "right":
            new_sprite = idle_right;
            break;
        case "left":
            new_sprite = idle_left;
            break;
        case "front":
            new_sprite = idle_front;
            break;
        case "back":
            new_sprite = idle_back;
            break;
        default:
            new_sprite = idle_front;
            break;
    }
    
    if (new_sprite != -1 && sprite_index != new_sprite) {
        var old_frame = image_index;
        var old_speed = image_speed;
        var old_sprite = sprite_index;
        
        var old_visual_x = x - sprite_get_xoffset(old_sprite);
        var old_visual_y = y - sprite_get_yoffset(old_sprite);
        
        sprite_index = new_sprite;
        
        x = old_visual_x + sprite_get_xoffset(new_sprite);
        y = old_visual_y + sprite_get_yoffset(new_sprite);
        
        if (sprite_get_number(sprite_index) > 0) {
            var frame_ratio = old_frame / max(sprite_get_number(sprite_index), 1);
            image_index = frame_ratio * sprite_get_number(sprite_index);
            image_index = clamp(image_index, 0, sprite_get_number(sprite_index) - 1);
        }
        image_speed = old_speed;
    }
}