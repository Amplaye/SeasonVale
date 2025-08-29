// Gestione effetto shake quando colpito
if (shake_timer > 0) {
    shake_timer--;
    
    // Calcola offset shake
    var shake_x = cos(shake_direction) * shake_intensity;
    var shake_y = sin(shake_direction) * shake_intensity;
    
    // Applica shake
    x = original_x + shake_x;
    y = original_y + shake_y;
    
    // Riduci intensità progressivamente
    shake_intensity *= 0.85;
    
    // Cambia direzione per effetto oscillazione
    shake_direction += pi/4;
} else {
    // Ritorna alla posizione originale
    x = original_x;
    y = original_y;
}

