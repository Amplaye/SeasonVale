// NPC Base Draw - Draw with consistent origin like player

// Draw the NPC with proper alignment (bottom center like player)
// Using draw_sprite instead of draw_self ensures consistent positioning
draw_sprite(sprite_index, image_index, x, y);

// Debug info (remove in production) - DISABILITATO
// if (global.npc_debug_mode) {
//     draw_set_color(c_yellow);
//     draw_circle(x, y, npc_talk_range, true);
//     draw_set_color(c_white);

//     draw_set_font(-1);
//     draw_text(x - 20, y - 40, npc_data[$ "name"] ?? "NPC");
//     draw_text(x - 20, y - 30, npc_state);
// }