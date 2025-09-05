// ===================================================================
// 🚜 SCRIPT AUTOTILING FARMING - USA TEMPLATE GAMEMAKER
// ===================================================================

/// @description Piazza una tile usando l'autotileset di GameMaker
/// @param {Id.TileMap} tilemap_id ID del tilemap
/// @param {real} autotile_index Indice dell'autotileset (1 = "street")
/// @param {real} tile_x Coordinata X della tile
/// @param {real} tile_y Coordinata Y della tile

function scr_farming_autotile(tilemap_id, autotile_index, tile_x, tile_y) {
    // BASATO SUI TILE ID REALI DEL TUO ROOM EDITOR
    // Analizziamo i 4 vicini cardinali per scegliere la tile corretta
    
    var n = scr_is_farming_tile(tile_x, tile_y - 1);     // Nord
    var e = scr_is_farming_tile(tile_x + 1, tile_y);     // Est  
    var s = scr_is_farming_tile(tile_x, tile_y + 1);     // Sud
    var w = scr_is_farming_tile(tile_x - 1, tile_y);     // Ovest
    
    // Ora uso i VERI pattern che vedo nel tuo room editor:
    var chosen_tile = 31; // Default isolato
    
    if (!n && !e && !s && !w) chosen_tile = 31;      // Isolato
    else if (!n && e && !s && !w) chosen_tile = 34;  // Solo est -> visto nel tuo room
    else if (!n && !e && !s && w) chosen_tile = 33;  // Solo ovest -> visto nel tuo room  
    else if (!n && e && !s && w) chosen_tile = 32;   // Orizzontale -> visto nel tuo room (30,31,32)
    else if (n && !e && !s && !w) chosen_tile = 4;   // Solo nord -> visto nel tuo room
    else if (!n && !e && s && !w) chosen_tile = 3;   // Solo sud -> visto nel tuo room
    else if (n && !e && s && !w) chosen_tile = 61;   // Verticale -> visto nel tuo room 
    else if (n && e && !s && !w) chosen_tile = 1;    // Nord+Est -> visto nel tuo room
    else if (n && !e && !s && w) chosen_tile = 2;    // Nord+Ovest -> visto nel tuo room
    else if (!n && e && s && !w) chosen_tile = 63;   // Est+Sud -> visto nel tuo room
    else if (!n && !e && s && w) chosen_tile = 64;   // Sud+Ovest -> visto nel tuo room
    else if (n && e && s && !w) chosen_tile = 60;    // T verso ovest -> visto nel tuo room
    else if (n && !e && s && w) chosen_tile = 62;    // T verso est -> visto nel tuo room
    else if (!n && e && s && w) chosen_tile = 310;   // T verso nord -> visto nel tuo room
    else if (n && e && !s && w) chosen_tile = 30;    // T verso sud -> visto nel tuo room
    else if (n && e && s && w) chosen_tile = 0;      // Centro completo -> visto nel tuo room
    
    tilemap_set(tilemap_id, chosen_tile, tile_x, tile_y);
    
    var pattern = (n ? "N" : "") + (e ? "E" : "") + (s ? "S" : "") + (w ? "W" : "");
    show_debug_message("🚜 Pattern " + pattern + " -> REALE Tile ID " + string(chosen_tile) + " a " + string(tile_x) + "," + string(tile_y));
    return chosen_tile;
}

/// @description Verifica se una tile è stata zappata
/// @param {real} check_x Coordinata X da verificare
/// @param {real} check_y Coordinata Y da verificare
/// @return {bool} True se la tile è zappata

function scr_is_farming_tile(check_x, check_y) {
    var tile_key = string(check_x) + "," + string(check_y);
    return ds_map_exists(global.farmed_tiles, tile_key);
}