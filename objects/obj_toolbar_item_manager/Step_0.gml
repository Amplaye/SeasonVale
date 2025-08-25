// ===================================================================
// 📦 TOOLBAR ITEM MANAGER - CONTINUOUS MONITORING
// ===================================================================

// ===== CONTROLLI DEBUG =====
// Ctrl+A = Toggle auto-positioning
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("A"))) {
    auto_positioning_enabled = !auto_positioning_enabled;
    var status = auto_positioning_enabled ? "ON" : "OFF";
    show_debug_message("🤖 Auto-posizionamento: " + status);
}

// Ctrl+R = Force repositioning
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("R"))) {
    show_debug_message("🔄 Forzando riposizionamento items...");
    toolbar_auto_position_items();
}

// ===== AUTO-POSITIONING PERIODICO =====
if (auto_positioning_enabled) {
    check_timer++;
    if (check_timer >= check_interval) {
        check_timer = 0;
        
        // Controlla se qualche item è stato spostato manualmente
        var needs_update = false;
        
        for (var i = 0; i < array_length(managed_items); i++) {
            var item = managed_items[i];
            if (item.assigned_slot != -1) {
                var current_x = layer_sprite_get_x(item.id);
                var current_y = layer_sprite_get_y(item.id);
                var slot_center = item_manager_get_slot_center(item.assigned_slot + 1);
                
                // Se l'item è troppo lontano dal centro del suo slot
                var distance = point_distance(current_x, current_y, slot_center.x, slot_center.y);
                if (distance > 10) { // Tolleranza di 10 pixel
                    needs_update = true;
                    break;
                }
            }
        }
        
        if (needs_update) {
            toolbar_auto_position_items();
        }
    }
}