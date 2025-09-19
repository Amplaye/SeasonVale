// ===================================================================
// 🚜 FARMING TEST SYSTEM - SISTEMA DI TEST PER AUTOTILING
// ===================================================================

depth = -2000; // Farming manager - layer Meta

// ===== CONFIGURAZIONE FARMING TEST =====
// Usa layer "soil" per i test con tiles diverse
farming_tilemap_layer = layer_get_id("soil");
farming_tilemap = layer_tilemap_get_id(farming_tilemap_layer);

// Usiamo l'autotileset "soil" per test con tiles diverse
farming_autotile_index = 2; // "soil" è il terzo autotileset (0=flor, 1=street, 2=soil)

// Tile ID dell'autotileset soil per test - diverse da street
// TEST: Useremo un set di tile diverse per sperimentare
farming_test_tiles = [100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115];
farming_base_tile_id = 100; // Tile base diversa per test

// Verifica che il tilemap esista
if (farming_tilemap == -1) {
    show_debug_message("⚠️ TEST ERRORE: Layer 'soil' non trovato nella room!");
} else {
    show_debug_message("🚜 Farming TEST inizializzato - Tilemap SOIL trovato: " + string(farming_tilemap));
    
    // Debug: Mostra info sul tilemap
    show_debug_message("🚜 TEST Tilemap width: " + string(tilemap_get_width(farming_tilemap)));
    show_debug_message("🚜 TEST Tilemap height: " + string(tilemap_get_height(farming_tilemap)));
    show_debug_message("🚜 TEST Tile size: " + string(tilemap_get_tile_width(farming_tilemap)) + "x" + string(tilemap_get_tile_height(farming_tilemap)));
}

// ===== STORAGE PERSISTENTE TEST =====
// Array globale separato per tracciare le posizioni zappate nei test
if (!variable_global_exists("farmed_tiles")) {
    global.farmed_tiles = ds_map_create();
    show_debug_message("🚜 Creato storage TEST per tile zappate");
}

// ===== CONFIGURAZIONE TOOL =====
// Verifica che lo sprite hoe esista
if (sprite_exists(spr_hoe)) {
    show_debug_message("🚜 Sprite zappa trovato: " + sprite_get_name(spr_hoe));
} else {
    show_debug_message("⚠️ ERRORE: Sprite 'hoe' non trovato!");
}

// ===== VARIABILI DI STATO =====
mouse_was_pressed = false; // Per evitare multi-click
farming_cooldown = 0; // Cooldown tra azioni di farming
farming_range = 32; // Distanza massima per zappare (in pixel)

// ===== DEBUG =====
show_farming_debug = false; // Mostra debug visivo delle tile zappabili

// ===== AUTOTILING GESTITO TRAMITE SCRIPT =====
// Le funzioni di autotiling sono ora nel file scr_farming_autotile.gml

// ===== NASCONDI TILEMAP FARMING PER SISTEMA DISCRETO =====
if (farming_tilemap_layer != -1) {
    layer_set_visible(farming_tilemap_layer, false);
    show_debug_message("🚜 Layer farming tilemap nascosto - usando solo quadrati discreti");
}

show_debug_message("🚜 Farming DISCRETO Manager creato - sistema a quadrati separati");