// ===================================================================
// 🎨 NOTIFICATION SPRITE MANAGER - GESTIONE SCALING E OFFSET
// ===================================================================

/// @function init_notification_sprite_settings()
/// @description Inizializza le impostazioni INDIPENDENTI per ogni sprite nelle notifiche
function init_notification_sprite_settings() {
    global.notification_sprite_settings = {};

    // ===== CONFIGURAZIONI SPRITE NOTIFICHE (SEPARATE DA INVENTORY/TOOLBAR) =====

    // Rock - configurato specificamente per notifiche
    global.notification_sprite_settings[$ "spr_rock"] = {
        scale: 1,
        offset_x: 2,
        offset_y: 6
    };

    // Wood - configurato specificamente per notifiche (SEPARATO da scaling_manager)
    global.notification_sprite_settings[$ "spr_wood"] = {
        scale: 0.6,
        offset_x: -10,
        offset_y: -1
    };

    // VERDURE - configurazioni indipendenti per notifiche
    global.notification_sprite_settings[$ "spr_tomato"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_carrot"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_potato"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_corn"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_aubergine"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_pepper"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_onion"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_garlic"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_pumpkin"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_lettuce"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_cucumber"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    // ATTREZZI - configurazioni indipendenti per notifiche
    global.notification_sprite_settings[$ "spr_axe"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_hoe"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_pickaxe"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    global.notification_sprite_settings[$ "spr_fishing_rod"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    // MATERIALI
    global.notification_sprite_settings[$ "spr_bronze"] = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    // Default settings per sprite non configurati
    global.notification_sprite_default = {
        scale: 0.4,
        offset_x: 0,
        offset_y: 0
    };

    show_debug_message("🎨 Notification Sprite Manager inizializzato (INDIPENDENTE da inventory/toolbar)");
}

/// @function get_notification_sprite_settings(sprite_id)
/// @description Ottieni le impostazioni per un sprite specifico
/// @param {asset.GMSprite} sprite_id - ID dello sprite
/// @return {struct} Struct con scale, offset_x, offset_y
function get_notification_sprite_settings(sprite_id) {
    // Assicurati che il sistema sia inizializzato
    if (!variable_global_exists("notification_sprite_default")) {
        init_notification_sprite_settings();
    }

    if (!sprite_exists(sprite_id)) {
        return global.notification_sprite_default;
    }

    var sprite_name = sprite_get_name(sprite_id);

    if (variable_global_exists("notification_sprite_settings") &&
        variable_struct_exists(global.notification_sprite_settings, sprite_name)) {
        return global.notification_sprite_settings[$ sprite_name];
    } else {
        return global.notification_sprite_default;
    }
}

/// @function set_notification_sprite_settings(sprite_name, scale, offset_x, offset_y)
/// @description Imposta le configurazioni per uno sprite specifico
/// @param {string} sprite_name - Nome dello sprite
/// @param {real} scale - Scala dello sprite
/// @param {real} offset_x - Offset X
/// @param {real} offset_y - Offset Y
function set_notification_sprite_settings(sprite_name, scale, offset_x, offset_y) {
    // Assicurati che il sistema sia inizializzato
    if (!variable_global_exists("notification_sprite_settings")) {
        init_notification_sprite_settings();
    }

    global.notification_sprite_settings[$ sprite_name] = {
        scale: scale,
        offset_x: offset_x,
        offset_y: offset_y
    };

    show_debug_message("🎨 Impostazioni aggiornate per " + sprite_name + ": scale=" + string(scale) + " offset=(" + string(offset_x) + "," + string(offset_y) + ")");
}

/// @function draw_notification_sprite(sprite_id, x, y)
/// @description Disegna uno sprite con le impostazioni corrette per le notifiche
/// @param {asset.GMSprite} sprite_id - ID dello sprite da disegnare
/// @param {real} x - Posizione X base
/// @param {real} y - Posizione Y base
/// @param {real} alpha - Alpha del disegno (opzionale, default 1.0)
function draw_notification_sprite(sprite_id, x, y, alpha = 1.0) {
    if (!sprite_exists(sprite_id)) {
        return;
    }

    var settings = get_notification_sprite_settings(sprite_id);

    var final_x = x + settings.offset_x;
    var final_y = y + settings.offset_y;

    draw_sprite_ext(sprite_id, 0, final_x, final_y,
                   settings.scale, settings.scale, 0, c_white, alpha);
}