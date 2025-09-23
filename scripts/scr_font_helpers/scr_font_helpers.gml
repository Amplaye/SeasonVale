/// @description Funzioni helper per la gestione dei font

// Variabili globali per controllo dimensioni
global.font_scale = 1.0;  // Scala generale del font (0.7 = 70% della dimensione originale)
global.ui_font_scale = 1.0;  // Scala font UI

/// @function set_main_font()
/// @description Imposta il font sprite principale
function set_main_font() {
    // Usa il font sprite spr_fontBasic
    if (variable_global_exists("font_main") && global.font_main != undefined) {
        draw_set_font(global.font_main);
    } else {
        draw_set_font(-1); // Fallback al font di sistema
    }
}

/// @function draw_text_scaled(xx, yy, str)
/// @description Disegna testo con scaling automatico
/// @param {real} xx - Posizione X
/// @param {real} yy - Posizione Y
/// @param {string} str - Testo da disegnare
function draw_text_scaled(xx, yy, str) {
    set_main_font();
    draw_text_transformed(xx, yy, str, global.font_scale, global.font_scale, 0);
}

/// @function set_small_font()
/// @description Imposta il font piccolo per UI
function set_small_font() {
    if (variable_global_exists("font_small") && global.font_small != undefined) {
        draw_set_font(global.font_small);
    } else {
        draw_set_font(-1); // Font di default di GameMaker
    }
}

/// @function draw_text_ui(xx, yy, str)
/// @description Disegna testo UI con font small
/// @param {real} xx - Posizione X
/// @param {real} yy - Posizione Y
/// @param {string} str - Testo da disegnare
function draw_text_ui(xx, yy, str) {
    set_small_font();
    draw_text_transformed(xx, yy, str, global.ui_font_scale, global.ui_font_scale, 0);
}

/// @function set_font_scale(scale)
/// @description Cambia la scala del font principale
/// @param {real} scale - Nuova scala (0.5 = 50%, 1.0 = 100%, 1.5 = 150%)
function set_font_scale(scale) {
    global.font_scale = scale;
    show_debug_message("📏 Font scale changed to: " + string(scale * 100) + "%");
}

/// @function draw_text_ext_scaled(xx, yy, str, sep, w)
/// @description Disegna testo esteso con scaling automatico
/// @param {real} xx - Posizione X
/// @param {real} yy - Posizione Y
/// @param {string} str - Testo da disegnare
/// @param {real} sep - Separazione linee
/// @param {real} w - Larghezza massima
function draw_text_ext_scaled(xx, yy, str, sep, w) {
    set_main_font();
    // Scala la separazione e larghezza insieme al testo
    draw_text_ext_transformed(xx, yy, str, sep * global.font_scale, w / global.font_scale, global.font_scale, global.font_scale, 0);
}

// ===== SCALE INDIVIDUALI PER OGNI TIPO DI TESTO =====
// Queste variabili vengono inizializzate dal Font Manager
// Modificale in obj_font_manager/Create_0.gml

// ===== FUNZIONI SPECIFICHE PER OGNI TIPO =====

/// @function draw_dialogue_text(xx, yy, text)
function draw_dialogue_text(xx, yy, text) {
    if (variable_global_exists("font_main") && global.font_main != undefined) {
        draw_set_font(global.font_main);
        draw_text_transformed(xx, yy, text, global.scale_dialogue, global.scale_dialogue, 0);
    }
}

/// @function draw_dialogue_text_ext(xx, yy, text, sep, w)
function draw_dialogue_text_ext(xx, yy, text, sep, w) {
    if (variable_global_exists("font_main") && global.font_main != undefined) {
        draw_set_font(global.font_main);
        draw_text_ext_transformed(xx, yy, text, sep * global.scale_dialogue, w / global.scale_dialogue, global.scale_dialogue, global.scale_dialogue, 0);
    }
}

/// @function draw_time_hud_text(xx, yy, text)
function draw_time_hud_text(xx, yy, text) {
    if (variable_global_exists("font_main") && global.font_main != undefined) {
        draw_set_font(global.font_main);
        draw_text_transformed(xx, yy, text, global.scale_time_hud, global.scale_time_hud, 0);
    }
}

/// @function draw_quest_text(xx, yy, text)
function draw_quest_text(xx, yy, text) {
    if (variable_global_exists("font_main") && global.font_main != undefined) {
        draw_set_font(global.font_main);
        draw_text_transformed(xx, yy, text, global.scale_quest_text, global.scale_quest_text, 0);
    }
}

/// @function draw_exit_menu_text(xx, yy, text)
function draw_exit_menu_text(xx, yy, text) {
    if (variable_global_exists("font_main") && global.font_main != undefined) {
        draw_set_font(global.font_main);
        draw_text_transformed(xx, yy, text, global.scale_exit_menu, global.scale_exit_menu, 0);
    }
}

/// @function draw_plant_hint_text(xx, yy, text)
function draw_plant_hint_text(xx, yy, text) {
    if (variable_global_exists("font_main") && global.font_main != undefined) {
        draw_set_font(global.font_main);
        draw_text_transformed(xx, yy, text, global.scale_plant_hints, global.scale_plant_hints, 0);
    }
}

/// @function draw_fps_text(xx, yy, text)
function draw_fps_text(xx, yy, text) {
    if (variable_global_exists("font_main") && global.font_main != undefined) {
        draw_set_font(global.font_main);
        draw_text_transformed(xx, yy, text, global.scale_fps_counter, global.scale_fps_counter, 0);
    }
}

/// @function draw_inventory_qty_text(xx, yy, text)
function draw_inventory_qty_text(xx, yy, text) {
    if (variable_global_exists("font_main") && global.font_main != undefined) {
        draw_set_font(global.font_main);
        draw_text_transformed(xx, yy, text, global.scale_inventory_qty, global.scale_inventory_qty, 0);
    }
}

/// @function draw_inventory_tooltip_text(xx, yy, text)
function draw_inventory_tooltip_text(xx, yy, text) {
    if (variable_global_exists("font_small") && global.font_small != undefined) {
        draw_set_font(global.font_small);
        draw_text_transformed(xx, yy, text, global.scale_inventory_tooltip, global.scale_inventory_tooltip, 0);
    }
}

/// @function draw_toolbar_qty_text(xx, yy, text)
function draw_toolbar_qty_text(xx, yy, text) {
    if (variable_global_exists("font_main") && global.font_main != undefined) {
        draw_set_font(global.font_main);
        draw_text_transformed(xx, yy, text, global.scale_toolbar_qty, global.scale_toolbar_qty, 0);
    }
}

/// @function draw_popup_title_text(xx, yy, text)
function draw_popup_title_text(xx, yy, text) {
    if (variable_global_exists("font_small") && global.font_small != undefined) {
        draw_set_font(global.font_small);
        draw_text_transformed(xx, yy, text, global.scale_popup_title, global.scale_popup_title, 0);
    }
}

/// @function draw_pickup_notification_text(xx, yy, text)
function draw_pickup_notification_text(xx, yy, text) {
    if (variable_global_exists("font_small") && global.font_small != undefined) {
        draw_set_font(global.font_small);
        draw_text_transformed(xx, yy, text, global.scale_pickup_notifications, global.scale_pickup_notifications, 0);
    }
}

/// @function fonts_ready()
/// @description Controlla se i font sono pronti per l'uso
function fonts_ready() {
    return (variable_global_exists("font_main") && global.font_main != undefined &&
            variable_global_exists("font_small") && global.font_small != undefined);
}