// ===================================================================
// 🌱 GRASS WIND EXAMPLE - RENDERING CON VENTO
// ===================================================================

// METODO 1: Utilizzo della funzione helper completa
apply_wind_to_sprite(grass_sprite, x, y, "grass", unique_wind_offset, grass_scale, grass_scale, 1.0);

// METODO 2: Calcolo manuale degli offset (per controllo maggiore)
/*
var wind_x = get_wind_offset_x("grass", unique_wind_offset);
var wind_y = get_wind_offset_y("grass", unique_wind_offset);
var wind_rotation = get_wind_rotation("grass", unique_wind_offset);

draw_sprite_ext(grass_sprite, 0, x + wind_x, y + wind_y,
               grass_scale, grass_scale, wind_rotation, c_white, 1.0);
*/

// ESEMPIO PER ALTRI TIPI:
// apply_wind_to_sprite(tree_sprite, x, y, "tree", unique_wind_offset);
// apply_wind_to_sprite(flower_sprite, x, y, "flower", unique_wind_offset);
// apply_wind_to_sprite(bush_sprite, x, y, "bush", unique_wind_offset);