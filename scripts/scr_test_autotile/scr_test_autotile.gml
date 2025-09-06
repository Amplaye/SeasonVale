function scr_test_autotile(tilemap_id, autotile_index, tile_x, tile_y) {
    
    // Controlla vicini
    var has_sopra = scr_test_is_farmed(tile_x, tile_y - 1);
    var has_destra = scr_test_is_farmed(tile_x + 1, tile_y);
    var has_sotto = scr_test_is_farmed(tile_x, tile_y + 1);
    var has_sinistra = scr_test_is_farmed(tile_x - 1, tile_y);
    
    // CORRETTA MAPPATURA TILE ID:
    // 312→259, 313→259, 225→195, 286→288, 316→318, 315→317, 285→287, 31→31
    var tile_index = 259; // Default (era 312)
    
    // Singolo tile isolato -> 259 (era 312) 
    if (!has_sopra && !has_destra && !has_sotto && !has_sinistra) {
        tile_index = 259;
    }
    // Espansione orizzontale -> 259 (era 313)
    else if (!has_sopra && !has_sotto && (has_destra || has_sinistra)) {
        tile_index = 259;
    }
    // 259 nella top row del 3x3 (ha sotto + lati) (era 313)
    else if (!has_sopra && has_sotto && has_destra && has_sinistra) {
        tile_index = 259;
    }
    // 259 nella bottom row del 3x3 (ha sopra + lati) (era 313)
    else if (has_sopra && !has_sotto && has_destra && has_sinistra) {
        tile_index = 259;
    }
    // Espansione verticale -> 195 (era 225)
    else if (has_sopra && has_sotto && !has_destra && !has_sinistra) {
        tile_index = 195;
    }
    // 195 colonna sinistra del 3x3 (era 225)
    else if (has_sopra && has_sotto && has_destra && !has_sinistra) {
        tile_index = 195;
    }
    // 195 colonna destra del 3x3 (era 225)  
    else if (has_sopra && has_sotto && !has_destra && has_sinistra) {
        tile_index = 195;
    }
    // Angoli del 3x3
    else if (!has_sopra && !has_destra && has_sotto && has_sinistra) {
        tile_index = 288; // top-right (era 286)
    }
    else if (has_sopra && !has_destra && !has_sotto && has_sinistra) {
        tile_index = 318; // bottom-right (era 316)
    }
    else if (has_sopra && has_destra && !has_sotto && !has_sinistra) {
        tile_index = 317; // bottom-left (era 315)
    }
    else if (!has_sopra && has_destra && has_sotto && !has_sinistra) {
        tile_index = 287; // top-left (era 285)
    }
    // Centro del 3x3 completo -> 31 (uguale)
    else if (has_sopra && has_sotto && has_destra && has_sinistra) {
        tile_index = 31;
    }
    else {
        tile_index = 259; // Fallback (era 312)
    }

    // Imposta il tile
    tilemap_set(tilemap_id, tile_index, tile_x, tile_y);

    // TRASFORMAZIONI DINAMICHE IDENTICHE - SOLO TILE ID CAMBIATI
    
    // 1. CAMBIO DA ORIZZONTALE A VERTICALE: 259→195, trasforma 259 in 288
    if (tile_index == 195) {
        if (has_sopra) {
            var tile_sopra = tilemap_get(tilemap_id, tile_x, tile_y - 1);
            if (tile_sopra == 259) {
                tilemap_set(tilemap_id, 288, tile_x, tile_y - 1);
            }
        }
    }
    
    // 2. CHIUSURA ORIZZONTALE: trasforma 195 in 318, cerca 259 e trasforma in 317
    if (tile_index == 195 && has_sinistra) {
        var tile_sinistra = tilemap_get(tilemap_id, tile_x - 1, tile_y);
        if (tile_sinistra == 195) {
            tilemap_set(tilemap_id, 318, tile_x, tile_y);
            var tile_sin_sin = tilemap_get(tilemap_id, tile_x - 2, tile_y);
            if (tile_sin_sin == 259) {
                tilemap_set(tilemap_id, 317, tile_x - 2, tile_y);
            }
        }
    }
    
    // 3. COMPLETAMENTO DEL 3x3: trova 259 e trasformalo in 287
    if (tile_index == 195 && has_sopra && has_destra) {
        for (var search_x = tile_x - 2; search_x <= tile_x + 2; search_x++) {
            for (var search_y = tile_y - 2; search_y <= tile_y + 2; search_y++) {
                if (scr_test_is_farmed(search_x, search_y)) {
                    var search_tile = tilemap_get(tilemap_id, search_x, search_y);
                    if (search_tile == 259) {
                        var right_tile = tilemap_get(tilemap_id, search_x + 1, search_y);
                        var bottom_tile = tilemap_get(tilemap_id, search_x, search_y + 1);
                        var diag_tile = tilemap_get(tilemap_id, search_x + 1, search_y + 1);
                        
                        if ((right_tile == 259 || right_tile == 288) && 
                            (bottom_tile == 195 || bottom_tile == 318) && 
                            (diag_tile == 318 || diag_tile == 195)) {
                            tilemap_set(tilemap_id, 287, search_x, search_y);
                        }
                    }
                }
            }
        }
    }

    // 4. COMPLETAMENTO 3x3: trasforma i lati finali
    for (var center_x = tile_x - 1; center_x <= tile_x + 1; center_x++) {
        for (var center_y = tile_y - 1; center_y <= tile_y + 1; center_y++) {
            if (scr_test_is_farmed(center_x, center_y)) {
                var center_tile = tilemap_get(tilemap_id, center_x, center_y);
                
                if (center_tile == 31 && 
                    scr_test_is_farmed(center_x - 1, center_y - 1) &&
                    scr_test_is_farmed(center_x, center_y - 1) &&
                    scr_test_is_farmed(center_x + 1, center_y - 1) &&
                    scr_test_is_farmed(center_x - 1, center_y) &&
                    scr_test_is_farmed(center_x + 1, center_y) &&
                    scr_test_is_farmed(center_x - 1, center_y + 1) &&
                    scr_test_is_farmed(center_x, center_y + 1) &&
                    scr_test_is_farmed(center_x + 1, center_y + 1)) {
                    
                    // Trasforma i 4 lati del quadrato 3x3 con i tuoi tile finali
                    var tile_top = tilemap_get(tilemap_id, center_x, center_y - 1);
                    if (tile_top == 259) {
                        tilemap_set(tilemap_id, 197, center_x, center_y - 1);
                    }
                    var tile_right = tilemap_get(tilemap_id, center_x + 1, center_y);
                    if (tile_right == 195) {
                        tilemap_set(tilemap_id, 196, center_x + 1, center_y);
                    }
                    var tile_bottom = tilemap_get(tilemap_id, center_x, center_y + 1);
                    if (tile_bottom == 259) {
                        tilemap_set(tilemap_id, 198, center_x, center_y + 1);
                    }
                    var tile_left = tilemap_get(tilemap_id, center_x - 1, center_y);
                    if (tile_left == 195) {
                        tilemap_set(tilemap_id, 194, center_x - 1, center_y);
                    }
                }
            }
        }
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