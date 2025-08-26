// ===================================================================
// 🚨 POPUP ERROR - LOGICA PRINCIPALE
// ===================================================================

// Controllo se le variabili globali esistono
if (!variable_global_exists("popup_active")) {
    show_debug_message("⚠️ Variabile global.popup_active non esiste ancora");
    exit;
}

// Controlla se il popup deve essere mostrato
if (global.popup_active && !visible) {
    // Mostra il popup
    visible = true;
    
    // Posiziona al centro schermo
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var screen_w = 480;
    var screen_h = 270;
    
    x = cam_x + (screen_w - sprite_width) / 2;
    y = cam_y + (screen_h - sprite_height) / 2;
    
    // Prepara il testo
    popup_title = "Inventario Pieno";
    
    show_debug_message("🚨 Popup mostrato al centro schermo - Pos: " + string(x) + "," + string(y));
}

// DEBUG: Test popup con tasto T
if (keyboard_check_pressed(ord("T"))) {
    if (!global.popup_active) {
        global.popup_active = true;
        global.popup_item_name = "rock";
        global.popup_quantity = 5;
        show_debug_message("🧪 TEST: Popup attivato manualmente con T");
    } else {
        global.popup_active = false;
        show_debug_message("🧪 TEST: Popup disattivato manualmente con T");
    }
}

// ALTERNATIVA: Controlla click nel Step event
if (visible && global.popup_active && mouse_check_button_pressed(mb_left)) {
    // Controlla se il click è sull'oggetto
    if (position_meeting(mouse_x, mouse_y, id)) {
        global.popup_active = false;
        show_debug_message("🚨 Popup chiuso con click STEP! Mouse: " + string(mouse_x) + "," + string(mouse_y));
    }
}

// Se il popup non deve più essere attivo, nascondilo
if (!global.popup_active && visible) {
    visible = false;
    show_debug_message("🚨 Popup nascosto");
}