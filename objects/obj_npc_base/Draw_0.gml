// NPC Base Draw - handled through depth sorting system
scr_addto_depthgrid();

// Debug info (remove in production) - DISABILITATO
// if (global.npc_debug_mode) {
//     draw_set_color(c_yellow);
//     draw_circle(x, y, npc_talk_range, true);
//     draw_set_color(c_white);

//     draw_set_font(-1);
//     draw_text(x - 20, y - 40, npc_data[$ "name"] ?? "NPC");
//     draw_text(x - 20, y - 30, npc_state);
// }