// ===================================================================
// 🚜 FARMING SYSTEM - SISTEMA AGRICOLTURA COMPLETO
// ===================================================================

depth = -500; // Sopra altri manager

// ===== CONFIGURAZIONE FARMING =====
// Torniamo al layer "street" per il colore terra desiderato
farming_tilemap_layer = layer_get_id("street");
farming_tilemap = layer_tilemap_get_id(farming_tilemap_layer);

// Usiamo l'autotileset "street" per la terra zappata
farming_autotile_index = 1; // "street" è il secondo autotileset (0=flor, 1=street, 2=soil)

// Tile ID dell'autotileset street - proviamo con diverse tile per l'autotiling
// Dal TileSet1.yy: "street" tiles = [31,34,33,1,4,30,64,310,3,63,32,2,61,60,62,0]
farming_street_tiles = [31, 34, 33, 1, 4, 30, 64, 310, 3, 63, 32, 2, 61, 60, 62, 0];
farming_base_tile_id = 31;

// Verifica che il tilemap esista
if (farming_tilemap == -1) {
    show_debug_message("⚠️ ERRORE: Layer 'street' non trovato nella room!");
} else {
    show_debug_message("🚜 Farming Manager inizializzato - Tilemap STREET trovato: " + string(farming_tilemap));
    
    // Debug: Mostra info sul tilemap
    show_debug_message("🚜 Tilemap width: " + string(tilemap_get_width(farming_tilemap)));
    show_debug_message("🚜 Tilemap height: " + string(tilemap_get_height(farming_tilemap)));
    show_debug_message("🚜 Tile size: " + string(tilemap_get_tile_width(farming_tilemap)) + "x" + string(tilemap_get_tile_height(farming_tilemap)));
}

// ===== STORAGE PERSISTENTE =====
// Array globale per tracciare le posizioni zappate (per persistenza tra room)
if (!variable_global_exists("farmed_tiles")) {
    global.farmed_tiles = ds_map_create();
    show_debug_message("🚜 Creato storage globale per tile zappate");
}

// ===== CONFIGURAZIONE TOOL =====
// Verifica che lo sprite hoe esista
if (sprite_exists(hoe)) {
    show_debug_message("🚜 Sprite zappa trovato: " + sprite_get_name(hoe));
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

show_debug_message("🚜 Farming Manager creato con autotiling migliorato");