// ===================================================================
// 📋 TOOLBAR CONTROLS & POSITIONING
// ===================================================================

// ===== GESTIONE POPUP INVENTARIO PIENO =====
// Il popup è ora gestito dall'oggetto obj_popup_error

// ===== SELEZIONE SLOT CON TASTI NUMERICI =====
for (var i = 1; i <= 9; i++) {
    if (keyboard_check_pressed(ord(string(i)))) {
        global.selected_tool = i - 1;
        show_debug_message("🎯 Selezionato Slot #" + string(i));
        break;
    }
}

// Tasto 0 per il decimo slot
if (keyboard_check_pressed(ord("0"))) {
    global.selected_tool = 9;
    show_debug_message("🎯 Selezionato Slot #10");
}

// ===== DEBUG CONTROLS (TASTIERA 60%) =====
// Ctrl+D = Toggle debug visuale slot
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("D"))) {
    global.toolbar_debug_enabled = !global.toolbar_debug_enabled;
    var status = global.toolbar_debug_enabled ? "ON" : "OFF";
    show_debug_message("🔍 Debug toolbar: " + status);
}

// Ctrl+R = Reset posizioni items
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("R"))) {
    show_debug_message("🔄 Reset posizioni items toolbar");
    // TODO: Implementeremo il reset automatico
}

// ===== POSIZIONAMENTO SLOT =====
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);

var screen_w = 480;
var screen_h = 270;

var slot_width = sprite_get_width(tool_slot);
var total_width = (global.toolbar_slots_count * slot_width) + ((global.toolbar_slots_count - 1) * global.toolbar_gap);

var toolbar_start_x = cam_x + (screen_w - total_width) / 2;
var toolbar_y = cam_y + screen_h - global.toolbar_distance_from_bottom;

// Calcola quale slot è questo oggetto
var my_slot_index = 0;
with (obj_toolbar) {
    if (id != other.id) my_slot_index++;
    if (id == other.id) break;
}

// Posiziona questo slot
x = toolbar_start_x + (my_slot_index * (slot_width + global.toolbar_gap));
y = toolbar_y;