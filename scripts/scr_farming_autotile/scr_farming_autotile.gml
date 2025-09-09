function scr_farming_autotile(tilemap_id, autotile_index, tile_x, tile_y) {
    
    // Non serve più il tracking delle direzioni
    
    // Controlla vicini
    var has_sopra = scr_is_farming_tile(tile_x, tile_y - 1);
    var has_destra = scr_is_farming_tile(tile_x + 1, tile_y);
    var has_sotto = scr_is_farming_tile(tile_x, tile_y + 1);
    var has_sinistra = scr_is_farming_tile(tile_x - 1, tile_y);
    
    // STEP 1: Inizia sempre con 311, poi analizza se trasformare
    var tile_index = 311; // Ogni nuovo tile inizia come 311
    
    // ANALISI: Determina se il tile 311 deve essere trasformato
    
    // Caso 1: Tile isolato -> mantieni 311
    if (!has_sopra && !has_destra && !has_sotto && !has_sinistra) {
        // Rimane 311, nessuna trasformazione
    }
    // Caso 2: Espansione orizzontale -> trasforma in 197
    else if (!has_sopra && !has_sotto && (has_destra || has_sinistra)) {
        // Controlla se questo tile è già un 198 (trasformazione speciale) - non sovrascriverlo
        var current_tile = tilemap_get(tilemap_id, tile_x, tile_y);
        if (current_tile == 198) {
            tile_index = 198; // Mantieni la trasformazione speciale
        } else {
            tile_index = 197; // Trasforma da 311 → 197
        }
    }
    // Caso 3: Top row del 3x3 -> trasforma in 197
    else if (!has_sopra && has_sotto && has_destra && has_sinistra) {
        // Controlla se questo tile è già un 198 (trasformazione speciale) - non sovrascriverlo
        var current_tile = tilemap_get(tilemap_id, tile_x, tile_y);
        if (current_tile == 198) {
            tile_index = 198; // Mantieni la trasformazione speciale
        } else {
            tile_index = 197; // Trasforma da 311 → 197
        }
    }
    // Caso 4: Bottom row -> trasforma in 198
    else if (has_sopra && !has_sotto && has_destra && has_sinistra) {
        tile_index = 198; // Trasforma da 311 → 198
    }
    // 198 quando inizi espansione verticale verso l'alto da linea orizzontale
    else if (!has_sopra && has_sotto && !has_destra && !has_sinistra) {
        // Controlla se sotto c'è una linea orizzontale
        var tile_sotto = tilemap_get(tilemap_id, tile_x, tile_y + 1);
        if (tile_sotto == 197) {
            // C'è una linea orizzontale sotto, questo dovrebbe essere 198 (bottom expansion)
            tile_index = 198;
        } else {
            // Espansione verticale: controlla se sono all'estremo sinistro o destro
            // Trova l'estremo sinistro della linea orizzontale
            var leftmost_x = tile_x;
            while (scr_is_farming_tile(leftmost_x - 1, tile_y - 1)) {
                leftmost_x--;
            }
            
            // Trova l'estremo destro della linea orizzontale  
            var rightmost_x = tile_x;
            while (scr_is_farming_tile(rightmost_x + 1, tile_y - 1)) {
                rightmost_x++;
            }
            
            // Se sono all'estremo sinistro -> 194, se all'estremo destro -> 196
            if (tile_x == leftmost_x) {
                tile_index = 194; // Estremo sinistro (X più bassa)
            } else if (tile_x == rightmost_x) {
                tile_index = 196; // Estremo destro (X più alta)  
            } else {
                tile_index = 194; // Default per posizioni intermedie
            }
        }
        
        // LOGICA SPECIALE: Quando espando verticalmente verso l'alto, 
        // il tile alla posizione X+1 E X-1 della linea orizzontale sotto cambia da 197→198
        if (has_sotto) {
            // Controlla posizione X+1 (destra)
            var target_x_right = tile_x + 1;
            var target_y = tile_y + 1;
            
            if (scr_is_farming_tile(target_x_right, target_y)) {
                var target_tile_right = tilemap_get(tilemap_id, target_x_right, target_y);
                if (target_tile_right == 197) {
                    tilemap_set(tilemap_id, 198, target_x_right, target_y);
                    show_debug_message("🔄 Trasformazione speciale (destra): tile in " + string(target_x_right) + "," + string(target_y) + " da 197→198");
                }
            }
            
            // Controlla posizione X-1 (sinistra)  
            var target_x_left = tile_x - 1;
            
            if (scr_is_farming_tile(target_x_left, target_y)) {
                var target_tile_left = tilemap_get(tilemap_id, target_x_left, target_y);
                if (target_tile_left == 197) {
                    tilemap_set(tilemap_id, 198, target_x_left, target_y);
                    show_debug_message("🔄 Trasformazione speciale (sinistra): tile in " + string(target_x_left) + "," + string(target_y) + " da 197→198");
                }
            }
        }
    }
    // Espansione verticale completa (ha sopra e sotto)
    else if (has_sopra && has_sotto && !has_destra && !has_sinistra) {
        // Trova la linea orizzontale più vicina (sopra o sotto)
        var reference_y = tile_y - 1; // Controlla la linea sopra
        
        // Se la linea sopra non esiste orizzontalmente, controlla sotto
        if (!scr_is_farming_tile(tile_x - 1, reference_y) && !scr_is_farming_tile(tile_x + 1, reference_y)) {
            reference_y = tile_y + 1; // Usa la linea sotto
        }
        
        // Trova gli estremi della linea orizzontale di riferimento
        var leftmost_x = tile_x;
        while (scr_is_farming_tile(leftmost_x - 1, reference_y)) {
            leftmost_x--;
        }
        
        var rightmost_x = tile_x;
        while (scr_is_farming_tile(rightmost_x + 1, reference_y)) {
            rightmost_x++;
        }
        
        // Se sono all'estremo sinistro -> 194, se all'estremo destro -> 196
        if (tile_x == leftmost_x) {
            tile_index = 194; // Estremo sinistro (X più bassa)
        } else if (tile_x == rightmost_x) {
            tile_index = 196; // Estremo destro (X più alta)
        } else {
            tile_index = 194; // Default per posizioni intermedie
        }
        
        // LOGICA SPECIALE: Quando completo un rettangolo con tile NS, 
        // trasforma i tile 197 centrali delle linee orizzontali in 198
        // Controlla linee orizzontali sopra e sotto
        for (var offset_y = -1; offset_y <= 1; offset_y += 2) { // -1 = sopra, +1 = sotto
            var check_y = tile_y + offset_y;
            
            // Trova la linea orizzontale a questa altezza
            var line_leftmost_x = tile_x;
            var line_rightmost_x = tile_x;
            
            // Trova estremi se esiste una linea orizzontale
            while (scr_is_farming_tile(line_leftmost_x - 1, check_y)) {
                line_leftmost_x--;
            }
            while (scr_is_farming_tile(line_rightmost_x + 1, check_y)) {
                line_rightmost_x++;
            }
            
            // Se c'è una linea orizzontale (più di 1 tile), controlla se formare rettangoli chiusi
            if (line_rightmost_x > line_leftmost_x) {
                for (var check_x = line_leftmost_x + 1; check_x < line_rightmost_x; check_x++) {
                    if (scr_is_farming_tile(check_x, check_y)) {
                        var check_tile = tilemap_get(tilemap_id, check_x, check_y);
                        if (check_tile == 197) {
                            // Verifica se questo tile è effettivamente al centro di un rettangolo chiuso
                            // Deve avere tile verticali sopra E sotto nella stessa colonna X
                            var has_vertical_above = scr_is_farming_tile(check_x, check_y - 1);
                            var has_vertical_below = scr_is_farming_tile(check_x, check_y + 1);
                            
                            // ESCLUSIONE: Non trasformare se fa parte di un 3x3 completo
                            // Controllo più rigoroso: deve avere tutti gli 8 vicini
                            var is_part_of_3x3 = (
                                scr_is_farming_tile(check_x - 1, check_y - 1) && // top-left
                                scr_is_farming_tile(check_x, check_y - 1) &&     // top
                                scr_is_farming_tile(check_x + 1, check_y - 1) && // top-right
                                scr_is_farming_tile(check_x - 1, check_y) &&     // left
                                scr_is_farming_tile(check_x + 1, check_y) &&     // right
                                scr_is_farming_tile(check_x - 1, check_y + 1) && // bottom-left
                                scr_is_farming_tile(check_x, check_y + 1) &&     // bottom
                                scr_is_farming_tile(check_x + 1, check_y + 1)    // bottom-right
                            );
                            
                            // Controllo alternativo: se ha vicini su tutti i 4 lati (potrebbe essere centro di 3x3)
                            var has_all_4_sides = (
                                scr_is_farming_tile(check_x, check_y - 1) &&    // sopra
                                scr_is_farming_tile(check_x + 1, check_y) &&    // destra
                                scr_is_farming_tile(check_x, check_y + 1) &&    // sotto
                                scr_is_farming_tile(check_x - 1, check_y)       // sinistra
                            );
                            
                            // NON trasformare se è parte di 3x3 O ha tutti i 4 lati
                            var should_block_transformation = is_part_of_3x3 || has_all_4_sides;
                            
                            if (has_vertical_above && has_vertical_below && !should_block_transformation) {
                                tilemap_set(tilemap_id, 198, check_x, check_y);
                                show_debug_message("🔄 Trasformazione rettangolo: tile in " + string(check_x) + "," + string(check_y) + " da 197→198");
                            } else if (has_vertical_above && has_vertical_below && should_block_transformation) {
                                show_debug_message("❌ BLOCCATA trasformazione: tile in " + string(check_x) + "," + string(check_y) + " resta 197 (3x3=" + string(is_part_of_3x3) + ", 4lati=" + string(has_all_4_sides) + ")");
                            }
                        }
                    }
                }
            }
        }
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

    // STEP 2: Applica il tile finale (sempre, anche se è 311)
    tilemap_set(tilemap_id, tile_index, tile_x, tile_y);
    
    // Controlla e aggiorna tiles adiacenti per trasformazioni 197 -> 198
    // Quando completi un quadrato, il tile 197 sopra dovrebbe diventare 198
    if (has_sopra) {
        var tile_sopra = tilemap_get(tilemap_id, tile_x, tile_y - 1);
        if (tile_sopra == 197) {
            // Controlla se il tile sopra ora ha tutti i vicini laterali per diventare 198
            var sopra_has_sinistra = scr_is_farming_tile(tile_x - 1, tile_y - 1);
            var sopra_has_destra = scr_is_farming_tile(tile_x + 1, tile_y - 1);
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
    
    show_debug_message("🚜 Pattern " + pattern_name + " -> Tile ID " + string(tile_index) + " a " + string(tile_x) + "," + string(tile_y));
    
    return tile_index;
}

/// @description Verifica se una tile è stata zappata
function scr_is_farming_tile(check_x, check_y) {
    var tile_key = string(check_x) + "," + string(check_y);
    return ds_map_exists(global.farmed_tiles, tile_key);
}