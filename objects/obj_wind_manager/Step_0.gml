// ===================================================================
// 🌬️ WIND MANAGER STEP - AGGIORNAMENTO VENTO
// ===================================================================

// Skip se vento disabilitato
if (!global.wind_enabled) {
    exit;
}

// ===== AGGIORNA TIMER GLOBALE =====
global.wind_time += wind_base_speed * global.wind_global_speed;

// ===== VARIAZIONE DINAMICA DIREZIONE =====
// Cambia lentamente la direzione principale del vento
wind_direction_offset += wind_direction_change_speed;
wind_main_direction = sin(wind_direction_offset) * 30; // Oscilla tra -30 e +30 gradi

// ===== VARIAZIONE DINAMICA INTENSITÀ =====
// Cambia lentamente l'intensità per vento più naturale
var intensity_variation = sin(global.wind_time * 0.3) * wind_intensity_variation;
wind_current_intensity = 1.0 + intensity_variation;

// Applica gradualmente verso target intensity
wind_current_intensity = lerp(wind_current_intensity, wind_target_intensity, 0.02);

// ===== CAMBIO CASUALE OCCASIONALE =====
// Ogni tanto cambia l'intensità target per variazione
if (irandom(1800) == 0) { // ~ogni 30 secondi a 60 FPS
    wind_target_intensity = random_range(0.7, 1.3);
    show_debug_message("🌬️ Nuova intensità target: " + string(wind_target_intensity));
}

// ===== DEBUG INFO (opzionale, commentabile) =====
// Uncomment per debug del vento
/*
if (global.wind_time mod 300 == 0) { // ogni 5 secondi
    show_debug_message("🌬️ Wind Status - Time: " + string(global.wind_time) +
                      " Direction: " + string(wind_main_direction) +
                      " Intensity: " + string(wind_current_intensity));
}
*/