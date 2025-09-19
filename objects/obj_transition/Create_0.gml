// === TRANSITION CREATE EVENT ===
// Le proprietà targetRoom, targetX, targetY sono definite nelle proprietà dell'oggetto

// Inizializza requiredDirection se non è già impostata
if (!variable_instance_exists(id, "requiredDirection") || requiredDirection == "") {
    requiredDirection = "any";
}

// Debug
show_debug_message("🚪 Transition created with direction: " + string(requiredDirection));