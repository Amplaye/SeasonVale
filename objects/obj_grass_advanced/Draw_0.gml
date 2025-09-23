// ===================================================================
// 🌱 ADVANCED GRASS DRAW - PIEGAMENTO REALISTICO INTEGRATO CON WIND SYSTEM
// ===================================================================

// Skip se vento disabilitato globalmente
if (!variable_global_exists("wind_enabled") || !global.wind_enabled) {
    // Disegna grass statica se vento disabilitato
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, image_alpha);
    exit;
}

// ===== CALCOLO MOVIMENTO INTEGRATO =====
// Combina wind system di SeasonVale con tecnica piegamento tutorial

// Ottieni movimento base dal wind system
var wind_x = get_wind_offset_x("grass", id + random_offset);
var wind_y = get_wind_offset_y("grass", id + random_offset);

// Calcolo tempo con parametri SeasonVale + variazione casuale
var time = global.wind_time + random_offset;
var time_based_offset = grass_intensity * cos(time * grass_speed + x / 50 + y / 50) *
                       global.wind_global_intensity *
                       (instance_exists(obj_wind_manager) ? obj_wind_manager.wind_current_intensity : 1.0);

// Combina movement wind system + time-based per naturalezza
var total_offset_x = (wind_x * 0.7) + (time_based_offset * 0.3) + grass_direction;
var total_offset_y = wind_y * 0.5; // Movimento verticale più sottile

// ===== SPRITE DEFORMATION SETUP =====
// Ottieni UV coordinates del sprite per cropping corretto
var uvs = sprite_get_uvs(sprite_index, image_index);

var crop_left = uvs[4] * image_xscale;
var crop_top = uvs[5] * image_yscale;
var crop_right = sprite_width - (uvs[6] * sprite_width) - crop_left;
var crop_bottom = sprite_height - (uvs[7] * sprite_height) - crop_top;

// ===== CALCOLO 4 PUNTI PER DEFORMAZIONE =====
// Top punti - si muovono con il vento (piegamento realistico)
var x1 = x - sprite_xoffset + total_offset_x + crop_left;
var y1 = y - sprite_yoffset + total_offset_y + crop_top;

var x2 = x - sprite_xoffset + sprite_width + total_offset_x - crop_right;
var y2 = y - sprite_yoffset + total_offset_y + crop_top;

// Bottom punti - rimangono fissi al terreno (radici ferme)
var x3 = x - sprite_xoffset + sprite_width - crop_right;
var y3 = y - sprite_yoffset + sprite_height - crop_bottom;

var x4 = x - sprite_xoffset + crop_left;
var y4 = y - sprite_yoffset + sprite_height - crop_bottom;

// ===== RENDERING FINALE =====
// Disegna grass con deformazione realistica
draw_sprite_pos(sprite_index, image_index, x1, y1, x2, y2, x3, y3, x4, y4, image_alpha);

// Debug rendering (commentabile)
/*
// Mostra punti di deformazione per debug
draw_set_color(c_red);
draw_circle(x1, y1, 2, false); // Top-left
draw_circle(x2, y2, 2, false); // Top-right
draw_set_color(c_blue);
draw_circle(x3, y3, 2, false); // Bottom-right
draw_circle(x4, y4, 2, false); // Bottom-left
draw_set_color(c_white);
*/