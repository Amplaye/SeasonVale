// ===================================================================
// 🛠️ PLANT DEVELOPMENT TOOL - DRAW GUI EVENT
// ===================================================================

// Solo se dev mode è attivo
if (!dev_mode_active) exit;

// Informazioni generali del sistema
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var info_x = 10;
var info_y = 10;
var line_height = 16;

draw_text(info_x, info_y, "🛠️ PLANT DEV TOOL ACTIVE");
info_y += line_height;

// Statistiche piante
var universal_plants = instance_number(obj_universal_plant);
var old_tomato_plants = instance_number(obj_tomato_plant);

draw_text(info_x, info_y, "Universal Plants: " + string(universal_plants));
info_y += line_height;
draw_text(info_x, info_y, "Old Tomato Plants: " + string(old_tomato_plants));
info_y += line_height;

// Seeds in toolbar
var seeds_in_toolbar = get_seeds_in_toolbar();
draw_set_color(c_aqua);
info_y += line_height;
draw_text(info_x, info_y, "Seeds in Toolbar: " + string(array_length(seeds_in_toolbar)));
for (var i = 0; i < array_length(seeds_in_toolbar); i++) {
    var seed_info = seeds_in_toolbar[i];
    if (sprite_exists(seed_info.sprite)) {
        info_y += line_height;
        draw_text(info_x + 20, info_y, "Slot " + string(seed_info.slot + 1) + ": " + sprite_get_name(seed_info.sprite) + " x" + string(seed_info.quantity));
    }
}

// Comandi
draw_set_color(c_yellow);
info_y += line_height;
draw_text(info_x, info_y, "Commands: [P]Toggle [I]Info [C]Create [G]Grow [H]Harvest [R]Remove");
info_y += line_height;
draw_text(info_x, info_y, "Seeds: [S]Add All [X]Remove [M]Refill [B]Buy Pack [D]Debug");
info_y += line_height;

// Informazioni dettagliate piante se attive
if (show_plant_info) {
    draw_set_color(c_lime);
    info_y += line_height;
    draw_text(info_x, info_y, "=== PLANT DETAILS ===");
    info_y += line_height;
    
    with (obj_universal_plant) {
        if (plant_type != "") {
            var plant_info = string_upper(plant_type) + " [" + string(growth_stage) + "/" + string(max_growth_stage) + "]";
            if (can_harvest) plant_info += " READY";
            if (harvest_cooldown > 0) plant_info += " CD:" + string(harvest_cooldown);
            
            draw_text(info_x, info_y, plant_info);
            info_y += line_height;
        }
    }
}

draw_set_color(c_white);