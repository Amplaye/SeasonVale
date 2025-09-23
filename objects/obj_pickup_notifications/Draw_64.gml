// ===================================================================
// 📢 PICKUP NOTIFICATIONS - DRAW GUI
// ===================================================================

// Se popup attivo, non disegnare notifiche
if (variable_global_exists("popup_active") && global.popup_active) {
    exit;
}

// Trova il player
var player_instance = instance_find(global.player_obj, 0);
if (player_instance == noone) exit;

// Converti posizione player in GUI coordinates (scalate correttamente)
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

// Calcola posizione relativa del player nella camera (0-1)
var player_rel_x = (player_instance.x - cam_x) / cam_w;
var player_rel_y = (player_instance.y - cam_y) / cam_h;

// Converti in coordinate GUI
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var player_gui_x = player_rel_x * gui_w;
var player_gui_y = player_rel_y * gui_h;

// Controlla se i font sono pronti
if (!fonts_ready()) {
    exit;
}

// Disegna ogni notifica
for (var i = 0; i < array_length(notifications); i++) {
    var notif = notifications[i];

    // Calcola posizione target per questa notifica (in coordinate GUI)
    notif.target_y = player_gui_y + notification_offset_y - (i * notification_height);

    // Animazione smooth scroll
    if (abs(notif.current_y - notif.target_y) > 1) {
        notif.current_y = lerp(notif.current_y, notif.target_y, 0.3);
    } else {
        notif.current_y = notif.target_y;
    }

    // Posizione finale (in coordinate GUI)
    var draw_x = player_gui_x + notification_offset_x;
    var draw_y = notif.current_y;

    // Imposta alpha per fade
    draw_set_alpha(notif.alpha);

    // Disegna sprite dell'item usando il notification sprite manager
    if (sprite_exists(notif.sprite_id)) {
        draw_notification_sprite(notif.sprite_id, draw_x - 18, draw_y - 7, notif.alpha);
        draw_x += 0; // sposta il testo a destra dello sprite
    }

    // Disegna testo "+1 [nome]" usando il nome vero dell'item
    draw_set_color(c_white);
    var real_item_name = get_item_name(notif.sprite_id);
    draw_pickup_notification_text(draw_x, draw_y, "+1 " + real_item_name);
}

// Reset alpha e font
draw_set_alpha(1.0);
draw_set_font(-1);