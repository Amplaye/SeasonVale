// ===================================================================
// 🧪 SCRIPT TEST AUTOTILING - SISTEMA PULITO PER SPERIMENTAZIONE
// ===================================================================

/// @description Sistema autotiling test completamente separato
/// @param tilemap_id   -> id del tilemap (da layer_tilemap_get_id)
/// @param autotile_index -> indice autotileset (non usato)
/// @param tile_x, tile_y -> cella griglia (non pixel!)

function scr_farming_test_autotile(tilemap_id, autotile_index, tile_x, tile_y) {
    
    // Controlla vicini usando la funzione test
    var has_sopra = scr_test_is_farmed(tile_x, tile_y - 1);
    var has_destra = scr_test_is_farmed(tile_x + 1, tile_y);
    var has_sotto = scr_test_is_farmed(tile_x, tile_y + 1);
    var has_sinistra = scr_test_is_farmed(tile_x - 1, tile_y);
    
    // TILE ID DEFINITI DALL'UTENTE:
    // 287 = top left, 288 = top right, 317 = bottom left, 318 = bottom right
    // 259 = espansione orizzontale, 195 = espansione verticale  
    // 31 = centro con tutti gli angoli collegati
    // 197 = top finale, 196 = right finale, 198 = bottom finale, 194 = left finale
    
    var tile_index = 259; // Default espansione orizzontale
    
    // Singolo tile isolato -> espansione orizzontale base
    if (!has_sopra && !has_destra && !has_sotto && !has_sinistra) {
        tile_index = 259; // Inizia con orizzontale
    }
    // Espansione orizzontale -> 259 (connesso solo lateralmente)
    else if (!has_sopra && !has_sotto && (has_destra || has_sinistra)) {
        tile_index = 259;
    }
    // Espansione verticale -> 195 (connesso sopra/sotto)
    else if (has_sopra && has_sotto && !has_destra && !has_sinistra) {
        tile_index = 195;
    }
    // Angoli del 3x3
    else if (!has_sopra && has_destra && has_sotto && !has_sinistra) {
        tile_index = 287; // top-left
    }
    else if (!has_sopra && !has_destra && has_sotto && has_sinistra) {
        tile_index = 288; // top-right  
    }
    else if (has_sopra && has_destra && !has_sotto && !has_sinistra) {
        tile_index = 317; // bottom-left
    }
    else if (has_sopra && !has_destra && !has_sotto && has_sinistra) {
        tile_index = 318; // bottom-right
    }
    // Centro del 3x3 completo -> 31
    else if (has_sopra && has_sotto && has_destra && has_sinistra) {
        tile_index = 31;
    }
    // Altri casi misti
    else if (has_sopra && has_sotto && has_destra && !has_sinistra) {
        tile_index = 195; // Colonna sinistra
    }
    else if (has_sopra && has_sotto && !has_destra && has_sinistra) {
        tile_index = 195; // Colonna destra  
    }
    else if (!has_sopra && has_sotto && has_destra && has_sinistra) {
        tile_index = 259; // Top row
    }
    else if (has_sopra && !has_sotto && has_destra && has_sinistra) {
        tile_index = 259; // Bottom row
    }
    else {
        tile_index = 259; // Fallback
    }

    // Imposta il tile
    tilemap_set(tilemap_id, tile_index, tile_x, tile_y);
    
    // CONTROLLO COMPLETAMENTO 3x3 E TRASFORMAZIONE FINALE
    // Quando piazzo un tile 31 (centro), controlla se è un 3x3 completo
    if (tile_index == 31) {
        scr_test_check_3x3_completion(tilemap_id, tile_x, tile_y);
    }
    
    var pattern_name = "";
    if (has_sopra) pattern_name += "N";
    if (has_destra) pattern_name += "E"; 
    if (has_sotto) pattern_name += "S";
    if (has_sinistra) pattern_name += "W";
    if (pattern_name == "") pattern_name = "isolato";
    
    show_debug_message("🧪 TEST Pattern " + pattern_name + " -> Tile ID " + string(tile_index) + " a " + string(tile_x) + "," + string(tile_y));
    return tile_index;
}

/// @description Verifica se una tile è stata zappata nel test
/// @param {real} check_x Coordinata X da verificare
/// @param {real} check_y Coordinata Y da verificare
/// @return {bool} True se la tile è zappata nei test

function scr_test_is_farmed(check_x, check_y) {
    var tile_key = string(check_x) + "," + string(check_y);
    return ds_map_exists(global.farmed_tiles_test, tile_key);
}

/// @description Controlla se un 3x3 è completo e trasforma i lati finali
/// @param tilemap_id ID del tilemap
/// @param center_x, center_y Coordinate del centro del 3x3
function scr_test_check_3x3_completion(tilemap_id, center_x, center_y) {
    
    // Controlla se tutti gli 8 vicini esistono (3x3 completo)
    if (scr_test_is_farmed(center_x - 1, center_y - 1) && // top-left
        scr_test_is_farmed(center_x, center_y - 1) &&     // top
        scr_test_is_farmed(center_x + 1, center_y - 1) && // top-right
        scr_test_is_farmed(center_x - 1, center_y) &&     // left
        scr_test_is_farmed(center_x + 1, center_y) &&     // right
        scr_test_is_farmed(center_x - 1, center_y + 1) && // bottom-left
        scr_test_is_farmed(center_x, center_y + 1) &&     // bottom
        scr_test_is_farmed(center_x + 1, center_y + 1)) { // bottom-right
        
        show_debug_message("🧪 3x3 COMPLETO! Trasformo i lati finali a " + string(center_x) + "," + string(center_y));
        
        // Trasforma i 4 lati con i tile finali
        // Top -> 197
        tilemap_set(tilemap_id, 197, center_x, center_y - 1);
        // Right -> 196  
        tilemap_set(tilemap_id, 196, center_x + 1, center_y);
        // Bottom -> 198
        tilemap_set(tilemap_id, 198, center_x, center_y + 1);
        // Left -> 194
        tilemap_set(tilemap_id, 194, center_x - 1, center_y);
        
        show_debug_message("🧪 Lati trasformati: TOP=197, RIGHT=196, BOTTOM=198, LEFT=194");
    }
}