// ===================================================================
// 🧪 FARMING TEST INPUT & LOGIC - GESTIONE ZAPPATURA TEST
// ===================================================================

// Aggiorna cooldown
if (farming_cooldown > 0) {
    farming_cooldown--;
}

// ===== VERIFICA CONDIZIONI PER FARMING =====
// 1. Player deve esistere
if (!instance_exists(obj_player)) exit;

// 2. Deve avere la zappa selezionata
var player_has_hoe = false;
var hoe_slot = -1;

// Controlla se ha la zappa nella toolbar
if (variable_global_exists("tool_sprites") && variable_global_exists("selected_tool")) {
    if (global.selected_tool >= 0 && global.selected_tool < array_length(global.tool_sprites)) {
        var selected_sprite = global.tool_sprites[global.selected_tool];
        if (sprite_exists(selected_sprite) && sprite_get_name(selected_sprite) == "hoe") {
            player_has_hoe = true;
            hoe_slot = global.selected_tool;
        }
    }
}

// Se non ha la zappa, esci
if (!player_has_hoe) {
    mouse_was_pressed = false;
    exit;
}

// ===== GESTIONE INPUT MOUSE =====
var mouse_pressed = mouse_check_button_pressed(mb_left);
var mouse_held = mouse_check_button(mb_left);

// Previeni multi-click
if (mouse_pressed && !mouse_was_pressed && farming_cooldown <= 0) {
    mouse_was_pressed = true;
    
    // ===== CALCOLA POSIZIONE TARGET =====
    var target_x = mouse_x;
    var target_y = mouse_y;
    
    // Trova il player
    var player = instance_find(obj_player, 0);
    if (player == noone) exit;
    
    // Verifica distanza dal player
    var distance_to_target = point_distance(player.x, player.y, target_x, target_y);
    if (distance_to_target > farming_range) {
        show_debug_message("🧪 TEST: Troppo lontano per zappare! Distanza: " + string(distance_to_target));
        mouse_was_pressed = false;
        exit;
    }
    
    // ===== CONVERTI COORDINATE IN TILE =====
    // Le tile sono 16x16 pixel
    var tile_x = floor(target_x / 16);
    var tile_y = floor(target_y / 16);
    
    // Verifica che la tile sia valida
    if (tile_x < 0 || tile_y < 0) {
        show_debug_message("🧪 TEST: Coordinate tile non valide: " + string(tile_x) + ", " + string(tile_y));
        mouse_was_pressed = false;
        exit;
    }
    
    // ===== ZAPPA LA TERRA =====
    if (farming_tilemap != -1) {
        // Ottieni tile corrente
        var current_tile = tilemap_get(farming_tilemap, tile_x, tile_y);
        
        // Crea key per storage globale
        var tile_key = string(tile_x) + "," + string(tile_y);
        
        // Verifica se già zappata (usa storage test)
        if (ds_map_exists(global.farmed_tiles_test, tile_key)) {
            show_debug_message("🧪 TEST: Tile già zappata a: " + string(tile_x) + ", " + string(tile_y));
        } else {
            // ===== USA AUTOTILING CON AGGIORNAMENTO VICINI =====
            // Salva prima nel storage TEST
            ds_map_add(global.farmed_tiles_test, tile_key, current_tile);
            
            // Piazza la nuova tile con autotiling TEST - usa script pulito
            var tilemap_id = layer_tilemap_get_id(farming_tilemap_layer);
            scr_test_autotile(tilemap_id, farming_autotile_index, tile_x, tile_y);
            
            // Aggiorna le tile vicine per autotiling corretto
            for (var dx = -1; dx <= 1; dx++) {
                for (var dy = -1; dy <= 1; dy++) {
                    if (dx == 0 && dy == 0) continue; // Salta il centro
                    
                    var neighbor_x = tile_x + dx;
                    var neighbor_y = tile_y + dy;
                    
                    // Se il vicino è una tile zappata TEST, ricalcola il suo autotiling
                    if (scr_test_is_farmed(neighbor_x, neighbor_y)) {
                        scr_test_autotile(tilemap_id, farming_autotile_index, neighbor_x, neighbor_y);
                    }
                }
            }
            
            // Feedback visivo e audio
            show_debug_message("🧪 TEST: Terra zappata con AUTOTILING a: " + string(tile_x) + ", " + string(tile_y) + " (era tile: " + string(current_tile) + ")");
            
            // Imposta cooldown
            farming_cooldown = 10; // 10 frame di cooldown
        }
    } else {
        show_debug_message("⚠️ TEST: Tilemap non disponibile per farming!");
    }
}

// Reset mouse state
if (!mouse_held) {
    mouse_was_pressed = false;
}

// ===== DEBUG TOGGLE TEST =====
if (keyboard_check_pressed(ord("G"))) {
    show_farming_debug = !show_farming_debug;
    show_debug_message("🧪 TEST Debug farming: " + (show_farming_debug ? "ON" : "OFF"));
}