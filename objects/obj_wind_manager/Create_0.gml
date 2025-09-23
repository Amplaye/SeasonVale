// ===================================================================
// 🌬️ WIND MANAGER - SISTEMA BREZZA GLOBALE
// ===================================================================

// Singleton pattern - solo un wind manager
if (instance_number(obj_wind_manager) > 1) {
    instance_destroy();
    exit;
}

depth = -15000; // Wind manager - layer Sistema
persistent = true; // Mantieni tra le room

// ===== PARAMETRI GLOBALI VENTO =====
global.wind_time = 0;                    // Timer principale del vento
global.wind_enabled = true;              // Enable/disable generale
global.wind_global_intensity = 1.0;     // Intensità globale (moltiplicatore)
global.wind_global_speed = 1.0;         // Velocità globale (moltiplicatore)

// ===== PARAMETRI BASE VENTO =====
wind_base_speed = 0.02;                  // Velocità base dell'oscillazione
wind_direction_change_speed = 0.005;     // Velocità cambio direzione
wind_intensity_variation = 0.3;          // Variazione intensità (0.0-1.0)

// ===== DIREZIONE E INTENSITÀ DINAMICHE =====
wind_main_direction = 0;                 // Direzione principale (angolo in gradi)
wind_direction_offset = 0;               // Offset direzione per variazione
wind_current_intensity = 1.0;           // Intensità corrente
wind_target_intensity = 1.0;            // Intensità target

// ===== PROFILI VENTO PER DIVERSI ELEMENTI =====
// Ogni profilo ha: amplitude, frequency, offset_variation
global.wind_profiles = {};

// ERBA - movimento delicato e frequente
global.wind_profiles[$ "grass"] = {
    amplitude: 2.0,          // Ampiezza movimento in pixel
    frequency: 1.0,          // Frequenza oscillazione
    offset_variation: 5.0,   // Variazione per evitare sincronizzazione
    damping: 0.8,           // Smorzamento del movimento
    direction_influence: 0.3 // Quanto influenza la direzione del vento
};

// ALBERI - movimento più lento e ampio
global.wind_profiles[$ "tree"] = {
    amplitude: 1.5,
    frequency: 0.6,
    offset_variation: 8.0,
    damping: 0.9,
    direction_influence: 0.5
};

// FIORI - movimento molto delicato
global.wind_profiles[$ "flower"] = {
    amplitude: 1.2,
    frequency: 1.2,
    offset_variation: 3.0,
    damping: 0.7,
    direction_influence: 0.2
};

// FOGLIE - movimento rapido e leggero
global.wind_profiles[$ "leaves"] = {
    amplitude: 0.8,
    frequency: 1.5,
    offset_variation: 2.0,
    damping: 0.6,
    direction_influence: 0.4
};

// ARBUSTI - movimento medio
global.wind_profiles[$ "bush"] = {
    amplitude: 1.8,
    frequency: 0.8,
    offset_variation: 6.0,
    damping: 0.85,
    direction_influence: 0.4
};

// ===== FUNZIONI UTILITÀ =====

/// @function get_wind_profile(profile_name)
/// @description Ottieni un profilo vento specifico
/// @param {string} profile_name - Nome del profilo
/// @return {struct} Profilo vento
function get_wind_profile(profile_name) {
    if (variable_struct_exists(global.wind_profiles, profile_name)) {
        return global.wind_profiles[$ profile_name];
    }
    // Default: grass profile
    return global.wind_profiles[$ "grass"];
}

/// @function set_wind_intensity(intensity)
/// @description Imposta l'intensità globale del vento
/// @param {real} intensity - Intensità (0.0 = no vento, 1.0 = normale, >1.0 = forte)
function set_wind_intensity(intensity) {
    global.wind_global_intensity = max(0, intensity);
    show_debug_message("🌬️ Intensità vento impostata: " + string(intensity));
}

/// @function set_wind_speed(speed)
/// @description Imposta la velocità globale del vento
/// @param {real} speed - Velocità moltiplicatore
function set_wind_speed(speed) {
    global.wind_global_speed = max(0.1, speed);
    show_debug_message("🌬️ Velocità vento impostata: " + string(speed));
}

/// @function toggle_wind()
/// @description Abilita/disabilita il vento globalmente
function toggle_wind() {
    global.wind_enabled = !global.wind_enabled;
    show_debug_message("🌬️ Vento " + (global.wind_enabled ? "abilitato" : "disabilitato"));
}

// ===== INIZIALIZZAZIONE =====
show_debug_message("🌬️ Wind Manager inizializzato");
show_debug_message("🌬️ Profili disponibili: " + string(variable_struct_names_count(global.wind_profiles)));

// Lista profili
var profile_names = variable_struct_get_names(global.wind_profiles);
for (var i = 0; i < array_length(profile_names); i++) {
    var name = profile_names[i];
    var profile = global.wind_profiles[$ name];
    show_debug_message("  - " + name + ": amp=" + string(profile.amplitude) + " freq=" + string(profile.frequency));
}