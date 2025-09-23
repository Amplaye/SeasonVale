// ===================================================================
// 🌱 GRASS WIND EXAMPLE - ESEMPIO UTILIZZO SISTEMA VENTO
// ===================================================================

// Crea wind manager se non esiste
create_wind_manager_if_needed();

// Parametri esempio erba
grass_sprite = spr_tomato; // Usa sprite esistente per demo (sostituire con sprite erba reale)
grass_scale = 1.0;

// Offset unico per questa istanza (evita sincronizzazione)
unique_wind_offset = id; // Usa instance ID come offset unico

show_debug_message("🌱 Grass example creato con offset: " + string(unique_wind_offset));