function scr_test_autotile(tilemap_id, autotile_index, tile_x, tile_y) {
    
    // Controlla vicini
    var has_sopra = scr_test_is_farmed(tile_x, tile_y - 1);
    var has_destra = scr_test_is_farmed(tile_x + 1, tile_y);
    var has_sotto = scr_test_is_farmed(tile_x, tile_y + 1);
    var has_sinistra = scr_test_is_farmed(tile_x - 1, tile_y);
    
    var tile_index = 311; // Default - centrato
    
    // Singolo tile isolato -> 311
    if (!has_sopra && !has_destra && !has_sotto && !has_sinistra) {
        tile_index = 311;
    }
    // Espansione orizzontale iniziale -> 197 (quando hai vicini orizzontali)
    else if (!has_sopra && !has_sotto && (has_destra || has_sinistra)) {
        tile_index = 197;
    }
    // 197 nella top row del 3x3 (ha sotto + lati)
    else if (!has_sopra && has_sotto && has_destra && has_sinistra) {
        tile_index = 197;
    }
    // 198 quando hai tile sopra e lati (bottom row scenario)
    else if (has_sopra && !has_sotto && has_destra && has_sinistra) {
        tile_index = 198;
    }
    // 198 quando inizi espansione verticale verso l'alto da linea orizzontale
    else if (!has_sopra && has_sotto && !has_destra && !has_sinistra) {
        // Controlla se sotto c'è una linea orizzontale
        var tile_sotto = tilemap_get(tilemap_id, tile_x, tile_y + 1);
        if (tile_sotto == 197) {
            // C'è una linea orizzontale sotto, questo dovrebbe essere 198 (bottom expansion)
            tile_index = 198;
        } else {
            // Espansione verso il basso: controlla posizione relativa al tile sopra
            // Se il tile sopra ha un tile a sinistra, questo è un'espansione a destra -> 196
            // Se il tile sopra ha un tile a destra, questo è un'espansione a sinistra -> 194
            
            var tile_sopra_has_sinistra = scr_test_is_farmed(tile_x - 1, tile_y - 1);
            var tile_sopra_has_destra = scr_test_is_farmed(tile_x + 1, tile_y - 1);
            
            if (tile_sopra_has_sinistra && !tile_sopra_has_destra) {
                tile_index = 194;
            } else if (tile_sopra_has_destra && !tile_sopra_has_sinistra) {
                tile_index = 196;
            } else {
                tile_index = 194;
            }
        }
    }
    // Espansione verticale completa (ha sopra e sotto)
    else if (has_sopra && has_sotto && !has_destra && !has_sinistra) {
        tile_index = 196; // Default per espansione verticale
    }
    // Colonna sinistra del 3x3 -> usa 194
    else if (has_sopra && has_sotto && has_destra && !has_sinistra) {
        tile_index = 194;
    }
    // Colonna destra del 3x3 -> usa 196
    else if (has_sopra && has_sotto && !has_destra && has_sinistra) {
        tile_index = 196;
    }
    // Angoli del 3x3
    else if (!has_sopra && !has_destra && has_sotto && has_sinistra) {
        tile_index = 288; // top-right
    }
    else if (has_sopra && !has_destra && !has_sotto && has_sinistra) {
        tile_index = 318; // bottom-right
    }
    else if (has_sopra && has_destra && !has_sotto && !has_sinistra) {
        tile_index = 317; // bottom-left
    }
    else if (!has_sopra && has_destra && has_sotto && !has_sinistra) {
        tile_index = 287; // top-left finale del 3x3
    }
    // Centro del 3x3 completo -> 311 (centrato)
    else if (has_sopra && has_sotto && has_destra && has_sinistra) {
        tile_index = 31;
    }
    else {
        tile_index = 311; // Fallback
    }

    // Imposta il tile
    tilemap_set(tilemap_id, tile_index, tile_x, tile_y);
    
    // Controlla e aggiorna tiles adiacenti per trasformazioni 197 -> 198
    // Quando completi un quadrato, il tile 197 sopra dovrebbe diventare 198
    if (has_sopra) {
        var tile_sopra = tilemap_get(tilemap_id, tile_x, tile_y - 1);
        if (tile_sopra == 197) {
            // Controlla se il tile sopra ora ha tutti i vicini laterali per diventare 198
            var sopra_has_sinistra = scr_test_is_farmed(tile_x - 1, tile_y - 1);
            var sopra_has_destra = scr_test_is_farmed(tile_x + 1, tile_y - 1);
            var sopra_has_sotto = true; // Questo tile appena piazzato
            
            if (sopra_has_sinistra && sopra_has_destra && sopra_has_sotto) {
                // Il tile sopra ora dovrebbe essere 198 (bottom row)
                // TESTING: Proviamo diversi ID per trovare quello visivamente corretto
                tilemap_set(tilemap_id, 198, tile_x, tile_y - 1);
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
function scr_test_is_farmed(check_x, check_y) {
    var tile_key = string(check_x) + "," + string(check_y);
    return ds_map_exists(global.farmed_tiles_test, tile_key);
}