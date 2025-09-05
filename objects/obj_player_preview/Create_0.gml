visible = false;
depth = -1001;

// Forza GameMaker a includere lo sprite nella compilazione
sprite_ref = idle_front;
base_sprite = idle_front;
current_frame = 0;
frame_speed = 8;

// Calcola l'offset dalla posizione dell'editor rispetto al centro del menu
// Coordinate del centro del menu nell'editor (provate empiricamente)
var editor_menu_center_x = 240;
var editor_menu_center_y = 180;

// Memorizza l'offset rispetto al centro del menu
offset_from_menu_x = x - editor_menu_center_x;
offset_from_menu_y = y - editor_menu_center_y;