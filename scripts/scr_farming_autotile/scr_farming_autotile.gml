// ===================================================================
// 🚜 SCRIPT AUTOTILING FARMING - USA TEMPLATE GAMEMAKER
// ===================================================================

/// @description Piazza una tile usando l'autotileset di GameMaker
/// @param {Id.TileMapElement} tilemap_id ID del tilemap
/// @param {real} autotile_index Indice dell'autotileset (1 = "street")
/// @param {real} tile_x Coordinata X della tile
/// @param {real} tile_y Coordinata Y della tile

/// @function scr_farming_autotile(tilemap_id, autotile_index, tile_x, tile_y)
/// @desc piazza un tile autotile e aggiorna i vicini per farming
/// @param tilemap_id   -> id del tilemap (da layer_tilemap_get_id)
/// @param autotile_index -> indice autotileset (non usato in questo approccio)
/// @param tile_x, tile_y -> cella griglia (non pixel!)

function scr_farming_autotile(tilemap_id, autotile_index, tile_x, tile_y) {
    
    // Controlla vicini
    var has_sopra = scr_is_farming_tile(tile_x, tile_y - 1);
    var has_destra = scr_is_farming_tile(tile_x + 1, tile_y);
    var has_sotto = scr_is_farming_tile(tile_x, tile_y + 1);
    var has_sinistra = scr_is_farming_tile(tile_x - 1, tile_y);
    
    // LOGICA DINAMICA DI TRASFORMAZIONE PER 3x3 PROGRESSIVO
    // Basata sulla tua sequenza: 312→313→286 con trasformazioni automatiche
    var tile_index = 312; // Default
    
    // Singolo tile isolato -> 312
    if (!has_sopra && !has_destra && !has_sotto && !has_sinistra) {
        tile_index = 312;
    }
    // Espansione orizzontale -> 313 (base: solo lati)
    else if (!has_sopra && !has_sotto && (has_destra || has_sinistra)) {
        tile_index = 313;
    }
    // 313 nella top row del 3x3 (ha sotto + lati)
    else if (!has_sopra && has_sotto && has_destra && has_sinistra) {
        tile_index = 313;
    }
    // 313 nella bottom row del 3x3 (ha sopra + lati) 
    else if (has_sopra && !has_sotto && has_destra && has_sinistra) {
        tile_index = 313;
    }
    // Espansione verticale -> 225 (colonna isolata)
    else if (has_sopra && has_sotto && !has_destra && !has_sinistra) {
        tile_index = 225;
    }
    // 225 colonna sinistra del 3x3 (ha sopra, sotto, destra)
    else if (has_sopra && has_sotto && has_destra && !has_sinistra) {
        tile_index = 225;
    }
    // 225 colonna destra del 3x3 (ha sopra, sotto, sinistra)  
    else if (has_sopra && has_sotto && !has_destra && has_sinistra) {
        tile_index = 225;
    }
    // Angoli del 3x3 (basati su pattern specifici)
    else if (!has_sopra && !has_destra && has_sotto && has_sinistra) {
        tile_index = 286; // top-right
    }
    else if (has_sopra && !has_destra && !has_sotto && has_sinistra) {
        tile_index = 316; // bottom-right del 3x3
    }
    else if (has_sopra && has_destra && !has_sotto && !has_sinistra) {
        tile_index = 315; // bottom-left
    }
    else if (!has_sopra && has_destra && has_sotto && !has_sinistra) {
        tile_index = 285; // top-left del 3x3
    }
    // Centro del 3x3 completo -> 31
    else if (has_sopra && has_sotto && has_destra && has_sinistra) {
        tile_index = 31; // Centro del 3x3 completo
    }
    else {
        tile_index = 312;
    }

    // Imposta il tile
    tilemap_set(tilemap_id, tile_index, tile_x, tile_y);

    // TRASFORMAZIONI DINAMICHE SECONDO LA TUA SEQUENZA ESATTA
    
    // 1. CAMBIO DA ORIZZONTALE A VERTICALE: 312 313 313 → 312 313 286
    if (tile_index == 225) {
        // Quando aggiungi il primo 225 verticale, trova l'ultimo 313 orizzontale e trasformalo in 286
        if (has_sopra) {
            var tile_sopra = tilemap_get(tilemap_id, tile_x, tile_y - 1);
            if (tile_sopra == 313) {
                tilemap_set(tilemap_id, 286, tile_x, tile_y - 1);
            }
        }
    }
    
    // 2. CHIUSURA ORIZZONTALE: bottom row completa → trasformazioni multiple
    if (tile_index == 225 && has_sinistra) {
        // Quando completi la bottom row, trasforma i tile appropriati
        var tile_sinistra = tilemap_get(tilemap_id, tile_x - 1, tile_y);
        if (tile_sinistra == 225) {
            // Trasforma questo in 316 (bottom-right)
            tilemap_set(tilemap_id, 316, tile_x, tile_y);
            // E cerca il 312 a sinistra per trasformarlo in 315 (bottom-left)
            var tile_sin_sin = tilemap_get(tilemap_id, tile_x - 2, tile_y);
            if (tile_sin_sin == 312) {
                tilemap_set(tilemap_id, 315, tile_x - 2, tile_y);
            }
        }
    }
    
    // 3. COMPLETAMENTO DEL 3x3: trasforma il centro originale 312 in 285
    // Quando il quadrato è quasi completo, trova e trasforma il 312 rimanente
    if (tile_index == 225 && has_sopra && has_destra) {
        // Scansiona l'area per trovare il 312 che deve diventare 285
        for (var search_x = tile_x - 2; search_x <= tile_x + 2; search_x++) {
            for (var search_y = tile_y - 2; search_y <= tile_y + 2; search_y++) {
                if (scr_is_farming_tile(search_x, search_y)) {
                    var search_tile = tilemap_get(tilemap_id, search_x, search_y);
                    if (search_tile == 312) {
                        // Verifica se questo 312 è circondato correttamente per diventare 285
                        var right_tile = tilemap_get(tilemap_id, search_x + 1, search_y);
                        var bottom_tile = tilemap_get(tilemap_id, search_x, search_y + 1);
                        var diag_tile = tilemap_get(tilemap_id, search_x + 1, search_y + 1);
                        
                        if ((right_tile == 313 || right_tile == 286) && 
                            (bottom_tile == 225 || bottom_tile == 316) && 
                            (diag_tile == 316 || diag_tile == 225)) {
                            tilemap_set(tilemap_id, 285, search_x, search_y);
                        }
                    }
                }
            }
        }
    }

    // 4. COMPLETAMENTO 3x3: controlla se abbiamo completato un quadrato 3x3
    // Controlla l'area 3x3 intorno al tile appena piazzato per pattern completi
    for (var center_x = tile_x - 1; center_x <= tile_x + 1; center_x++) {
        for (var center_y = tile_y - 1; center_y <= tile_y + 1; center_y++) {
            // Controlla se questo potrebbe essere il centro di un 3x3 completo
            if (scr_is_farming_tile(center_x, center_y)) {
                var center_tile = tilemap_get(tilemap_id, center_x, center_y);
                
                // Se il centro è 31 e ha tutti gli 8 vicini in un pattern 3x3
                if (center_tile == 31 && 
                    scr_is_farming_tile(center_x - 1, center_y - 1) && // top-left
                    scr_is_farming_tile(center_x, center_y - 1) &&     // top
                    scr_is_farming_tile(center_x + 1, center_y - 1) && // top-right
                    scr_is_farming_tile(center_x - 1, center_y) &&     // left
                    scr_is_farming_tile(center_x + 1, center_y) &&     // right
                    scr_is_farming_tile(center_x - 1, center_y + 1) && // bottom-left
                    scr_is_farming_tile(center_x, center_y + 1) &&     // bottom
                    scr_is_farming_tile(center_x + 1, center_y + 1)) { // bottom-right
                    
                    // Trasforma i 4 lati del quadrato 3x3
                    // Top -> 227
                    var tile_top = tilemap_get(tilemap_id, center_x, center_y - 1);
                    if (tile_top == 313) {
                        tilemap_set(tilemap_id, 227, center_x, center_y - 1);
                    }
                    // Right -> 226  
                    var tile_right = tilemap_get(tilemap_id, center_x + 1, center_y);
                    if (tile_right == 225) {
                        tilemap_set(tilemap_id, 226, center_x + 1, center_y);
                    }
                    // Bottom -> 228
                    var tile_bottom = tilemap_get(tilemap_id, center_x, center_y + 1);
                    if (tile_bottom == 313) {
                        tilemap_set(tilemap_id, 228, center_x, center_y + 1);
                    }
                    // Left -> 224
                    var tile_left = tilemap_get(tilemap_id, center_x - 1, center_y);
                    if (tile_left == 225) {
                        tilemap_set(tilemap_id, 224, center_x - 1, center_y);
                    }
                }
            }
        }
    }
    
    // Le trasformazioni dinamiche sopra gestiscono già tutti i casi necessari
    
    var pattern_name = "";
    if (has_sopra) pattern_name += "N";
    if (has_destra) pattern_name += "E"; 
    if (has_sotto) pattern_name += "S";
    if (has_sinistra) pattern_name += "W";
    if (pattern_name == "") pattern_name = "isolato";
    
    show_debug_message("🚜 Pattern " + pattern_name + " -> Tile ID " + string(tile_index) + " a " + string(tile_x) + "," + string(tile_y));
    return tile_index;
}

/// @description Verifica se una tile è stata zappata
/// @param {real} check_x Coordinata X da verificare
/// @param {real} check_y Coordinata Y da verificare
/// @return {bool} True se la tile è zappata

function scr_is_farming_tile(check_x, check_y) {
    var tile_key = string(check_x) + "," + string(check_y);
    return ds_map_exists(global.farmed_tiles, tile_key);
}