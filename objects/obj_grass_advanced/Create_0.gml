// ===================================================================
// 🌱 ADVANCED GRASS - EFFETTO PIEGAMENTO REALISTICO
// ===================================================================

// Depth sorting per rendering corretto
depth = -y;

// Offset casuale per variazione naturale (ogni grass diversa)
random_offset = random(2 * pi);

// Crea wind manager se necessario
create_wind_manager_if_needed();

// Parametri grass specifici per SeasonVale
grass_intensity = random_range(0.8, 1.2);  // Intensità movimento casuale
grass_speed = random_range(0.9, 1.1);      // Velocità movimento casuale
grass_direction = random_range(-0.3, 0.3); // Direzione preferita casuale

// Scale personalizzato per questo oggetto
image_xscale = random_range(0.8, 1.2);
image_yscale = random_range(0.9, 1.1);

show_debug_message("🌱 Advanced grass creata con offset: " + string(random_offset));