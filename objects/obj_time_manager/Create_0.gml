// Singleton pattern - solo un time manager
if (instance_number(obj_time_manager) > 1) {
    instance_destroy();
    exit;
}

// Inizializza variabili tempo SOLO se non esistono già
if (!variable_global_exists("game_day") || global.game_day == undefined) {
    global.game_day = 1;
}
if (!variable_global_exists("game_hour") || global.game_hour == undefined) {
    global.game_hour = 6;  // Inizia alle 6:00 AM
}
if (!variable_global_exists("game_minute") || global.game_minute == undefined) {
    global.game_minute = 0;
}

// Resetta flag di ripristino tempo (permette il caricamento quando si cambia room)
if (variable_global_exists("time_restored")) {
    global.time_restored = undefined;
}

// Configurazione tempo
minutes_per_hour = 60;
hours_per_day = 19;  // Dalle 6:00 alle 01:00 (19 ore giocabili)
min_hour = 6;        // 6:00 AM
max_hour = 25;       // 01:00 AM (25 = 1:00 del giorno dopo)

// Timer per avanzamento automatico tempo (opzionale - per ora disabilitato)
time_speed = 1;      // Secondi reali per minuto di gioco
auto_advance = false; // Per ora avanzamento manuale
time_timer = 0;

// Sistema giorno/notte - colori overlay
overlay_alpha = 0;
overlay_color = c_black;

// Definizione colori per ogni ora (dalle 6:00 alle 01:00)
// [colore, alpha] per ogni ora
time_colors = ds_map_create();

// 6:00-7:00 - Alba (arancione chiaro)
ds_map_add(time_colors, 6, [make_color_rgb(255, 200, 150), 0.1]);
ds_map_add(time_colors, 7, [make_color_rgb(255, 220, 180), 0.05]);

// 8:00-17:00 - Giorno (nessun overlay)
for (var h = 8; h <= 17; h++) {
    ds_map_add(time_colors, h, [c_white, 0]);
}

// 18:00-19:00 - Tramonto (arancione/rosso)
ds_map_add(time_colors, 18, [make_color_rgb(255, 180, 100), 0.15]);
ds_map_add(time_colors, 19, [make_color_rgb(255, 150, 80), 0.25]);

// 20:00-22:00 - Sera (blu scuro)
ds_map_add(time_colors, 20, [make_color_rgb(100, 100, 200), 0.35]);
ds_map_add(time_colors, 21, [make_color_rgb(80, 80, 180), 0.45]);
ds_map_add(time_colors, 22, [make_color_rgb(60, 60, 160), 0.55]);

// 23:00-01:00 - Notte (blu molto scuro/nero)
ds_map_add(time_colors, 23, [make_color_rgb(40, 40, 120), 0.65]);
ds_map_add(time_colors, 24, [make_color_rgb(20, 20, 80), 0.75]);
ds_map_add(time_colors, 25, [make_color_rgb(10, 10, 60), 0.8]); // 01:00

// Aggiorna overlay iniziale
update_time_overlay();

// Debug (disabled for performance)
// show_debug_message("Time Manager created - Day: " + string(global.game_day) + " Time: " + format_time());

// Funzione per formattare l'orario
function format_time() {
    var display_hour = global.game_hour;
    var am_pm = "AM";
    
    // Converti in formato 12 ore
    if (display_hour >= 13 && display_hour <= 23) {
        display_hour -= 12;
        am_pm = "PM";
    } else if (display_hour == 24) {
        display_hour = 12;
        am_pm = "AM";
    } else if (display_hour == 25) {
        display_hour = 1;
        am_pm = "AM";
    } else if (display_hour == 0) {
        display_hour = 12;
        am_pm = "AM";
    }
    
    var minute_str = string(global.game_minute);
    if (global.game_minute < 10) minute_str = "0" + minute_str;
    
    return string(display_hour) + ":" + minute_str + " " + am_pm;
}

// Funzione per aggiornare overlay tempo
function update_time_overlay() {
    if (ds_map_exists(time_colors, global.game_hour)) {
        var color_data = ds_map_find_value(time_colors, global.game_hour);
        overlay_color = color_data[0];
        overlay_alpha = color_data[1];
    } else {
        // Default per ore non definite
        overlay_color = c_black;
        overlay_alpha = 0;
    }
}

// Funzioni advance_day() e advance_hour() sono ora in scr_time_functions