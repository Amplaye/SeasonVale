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
chopping_direction = "front"; // Direzione salvata per l'animazione corrente
chop_cooldown = 0; // Cooldown dopo ogni chop


sprite_index = idle_front;
image_speed = 1;

// Cursore gestito da obj_cursor_manager

base_x = x;
base_y = y;

// Funzione per determinare direzione verso il cursor
function get_direction_to_cursor() {
    var dx = mouse_x - x;
    var dy = mouse_y - y;
    
    // Determina direzione basata su angolo (rimuovo il controllo distanza che causava problemi)
    var angle = point_direction(x, y, mouse_x, mouse_y);
    var result = "";
    
    // Converti angolo in direzione cardinale
    // GameMaker usa 0° = destra, 90° = su, 180° = sinistra, 270° = giù
    if (angle >= 315 || angle < 45) {
        result = "right";
    } else if (angle >= 45 && angle < 135) {
        result = "back";  // Su nella vista top-down
    } else if (angle >= 135 && angle < 225) {
        result = "left";
    } else { // angle >= 225 && angle < 315
        result = "front"; // Giù nella vista top-down
    }
    
    // Debug per vedere cosa sta calcolando
    show_debug_message("🎯 Cursor direction: angle=" + string(angle) + "° → direction=" + result);
    return result;
}