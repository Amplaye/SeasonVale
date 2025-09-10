// ===================================================================
// 🧪 FARMING TEST VISUAL DEBUG - INDICATORI VISIVI TEST
// ===================================================================

// Solo se debug è attivato
if (!show_farming_debug) exit;

// Verifica che player esista
if (!instance_exists(obj_player)) exit;

var player = instance_find(obj_player, 0);
if (player == noone) exit;

// ===== DISEGNA RANGE DI FARMING =====
// Cerchio semi-trasparente attorno al player (TEST - colore diverso)
draw_set_alpha(0.2);
draw_set_color(c_blue);
draw_circle(player.x, player.y, farming_range, false);
draw_set_alpha(1.0);

// Bordo del cerchio (TEST - colore diverso)
draw_set_color(c_aqua);
draw_circle(player.x, player.y, farming_range, true);

// ===== EVIDENZIA TILE TARGET =====
// Tile dove punta il mouse
var target_tile_x = floor(mouse_x / 16);
var target_tile_y = floor(mouse_y / 16);

// Converti back in coordinate pixel per il disegno
var target_pixel_x = target_tile_x * 16;
var target_pixel_y = target_tile_y * 16;

// Verifica se è nel range
var distance_to_target = point_distance(player.x, player.y, target_pixel_x + 8, target_pixel_y + 8);
var in_range = distance_to_target <= farming_range;

// Colore basato su range e stato
var tile_key = string(target_tile_x) + "," + string(target_tile_y);
var already_farmed = ds_map_exists(global.farmed_tiles, tile_key);

if (already_farmed) {
    draw_set_color(c_yellow); // Già zappata
} else if (in_range) {
    draw_set_color(c_lime); // Zappabile
} else {
    draw_set_color(c_red); // Fuori range
}

// Disegna rettangolo sulla tile target
draw_set_alpha(0.3);
draw_rectangle(target_pixel_x, target_pixel_y, target_pixel_x + 16, target_pixel_y + 16, false);
draw_set_alpha(1.0);

// Bordo della tile
draw_rectangle(target_pixel_x, target_pixel_y, target_pixel_x + 16, target_pixel_y + 16, true);

// ===== INFO TEXT =====
// Mostra info in alto a sinistra
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Ottieni tile ID corrente dove punta il mouse
var current_tile_id = tilemap_get(farming_tilemap, target_tile_x, target_tile_y);

var info_text = "FARMING TEST DEBUG (G to toggle)\n";
info_text += "Range: " + string(farming_range) + " pixels\n";
info_text += "Target Tile: " + string(target_tile_x) + ", " + string(target_tile_y) + "\n";
info_text += "TILE ID at mouse: " + string(current_tile_id) + "\n";
info_text += "Distance: " + string(round(distance_to_target)) + "\n";
info_text += "In Range: " + (in_range ? "YES" : "NO") + "\n";
info_text += "Already Farmed: " + (already_farmed ? "YES" : "NO") + "\n";
info_text += "Farmed Tiles Count: " + string(ds_map_size(global.farmed_tiles));

draw_text(10, 10, info_text);

// ===== DISEGNA TILE ID SULLA TILE =====
// Mostra l'ID della tile direttamente sulla tile dove punta il mouse
if (current_tile_id != 0) {
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(target_pixel_x + 8, target_pixel_y + 8, string(current_tile_id));
}

// Reset drawing settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);