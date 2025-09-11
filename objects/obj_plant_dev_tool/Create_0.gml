// ===================================================================
// 🛠️ PLANT DEVELOPMENT TOOL - STRUMENTO SVILUPPO PIANTE
// ===================================================================
// Tool per testare, debuggare e gestire il sistema piante
// Attivato solo in modalità sviluppo

depth = -10000; // Molto alto per essere eseguito prima

dev_mode_active = false;
show_plant_info = false;
selected_plant = noone;

// Lista delle piante di test da creare
test_plants = [
    {type: "tomato", x: 200, y: 200},
    {type: "carrot", x: 250, y: 200}
];

show_debug_message("🛠️ Plant Development Tool loaded");
show_debug_message("🛠️ Commands:");
show_debug_message("  P = Toggle plant dev mode");
show_debug_message("  I = Show plant info");
show_debug_message("  C = Create test plants");
show_debug_message("  G = Grow all plants +1 stage");
show_debug_message("  H = Harvest all ready plants");
show_debug_message("  R = Remove all plants");
show_debug_message("  D = Debug all plant configs");
show_debug_message("  S = Add all seeds to toolbar");
show_debug_message("  X = Remove all seeds from toolbar");
show_debug_message("  M = Refill seeds (more seeds)");
show_debug_message("  B = Buy starter seeds pack");