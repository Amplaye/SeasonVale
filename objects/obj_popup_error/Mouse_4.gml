// ===================================================================
// 🚨 POPUP ERROR - CLICK SULLA X PER CHIUDERE
// ===================================================================

// METODO SEMPLICE: Chiudi sempre quando clicchi sull'oggetto
if (visible && global.popup_active) {
    global.popup_active = false;
    show_debug_message("🚨 Popup chiuso con click! Mouse pos: " + string(mouse_x) + "," + string(mouse_y) + " Obj pos: " + string(x) + "," + string(y));
}