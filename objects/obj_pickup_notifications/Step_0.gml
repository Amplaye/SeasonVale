// ===================================================================
// 📢 PICKUP NOTIFICATIONS - STEP LOGIC
// ===================================================================

// Update notifiche esistenti
for (var i = array_length(notifications) - 1; i >= 0; i--) {
    var notif = notifications[i];

    // Decrementa timer
    notif.timer--;

    // Se il timer è finito, rimuovi la notifica
    if (notif.timer <= 0) {
        array_delete(notifications, i, 1);
    }
    // Se sta per finire, calcola fade
    else if (notif.timer <= fade_out_frames) {
        notif.alpha = notif.timer / fade_out_frames;
    }
}

// ===== FUNZIONE PER AGGIUNGERE NOTIFICA =====
function add_pickup_notification(sprite_id) {
    // Crea nuova notifica
    var new_notification = {
        sprite_id: sprite_id,
        timer: notification_duration,
        alpha: 1.0,
        target_y: 0, // verrà calcolato nel draw
        current_y: 0 // posizione corrente per animazione
    };

    // Aggiungi all'inizio dell'array (posizione più alta)
    array_insert(notifications, 0, new_notification);

    // Se supera il massimo, rimuovi le più vecchie
    if (array_length(notifications) > max_notifications) {
        array_resize(notifications, max_notifications);
    }

    var item_name = get_item_name(sprite_id);
    show_debug_message("📢 Added notification: " + item_name);
}