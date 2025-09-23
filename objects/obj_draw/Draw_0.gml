/// @description Draw Instances in Grid - Ottimizzato per Mac M2

// Imposta font principale del gioco
set_main_font();

if(ds_exists(ds_depthgrid, ds_type_grid)){

    //sort the grid by Y value (lowest Y values first)
    ds_grid_sort(ds_depthgrid, 1, true);

    // Ottimizzazione Mac: salta frame occasionalmente se molti oggetti
    // var platform = detect_platform();
    var platform = "mac"; // Temporary fix
    var grid_height = ds_grid_height(ds_depthgrid);
    var skip_frame = false;

    if (platform == "mac" && grid_height > 30) {
        // Su Mac con molti oggetti, salta 1 frame ogni 4
        skip_frame = (global.frame_count % 4 == 0);
        if (skip_frame) {
            // smart_debug_message("Mac optimization: skipping draw frame for " + string(grid_height) + " objects");
            show_debug_message("Mac optimization: skipping draw frame for " + string(grid_height) + " objects");
        }
    }

    //draw all of the instances in order (lowest Y value first)
    for(var yy = 0; yy < grid_height; yy += 1){
        
        //draw the instance
        var instanceID = ds_depthgrid[# 0, yy];

        // Su Mac, salta il draw se stiamo ottimizzando questo frame
        if (skip_frame && yy % 2 == 0) {
            continue;
        }

        with(instanceID){
            // Usa funzioni personalizzate per oggetti specifici
            if (object_index == obj_player) {
                draw_player_with_clothes();
                // Player collision debug - yellow border
                draw_set_color(c_yellow);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
                draw_set_color(c_white);
            } else if (object_index == obj_rock) {
                // Draw rock with shake effect - solo se sprite valido
                if (sprite_index != -1 && sprite_exists(sprite_index)) {
                    if (shake_timer > 0) {
                        var shake_x = cos(shake_direction) * shake_intensity;
                        var shake_y = sin(shake_direction) * shake_intensity;
                        draw_sprite_ext(sprite_index, image_index, x + shake_x, y + shake_y, 1, 1, 0, c_white, image_alpha);
                    } else {
                        draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, image_alpha);
                    }
                }
            } else if (object_index == obj_tree) {
                // Draw tree with frame-based wind (frame 0=tronco fisso, frame 1=foglie con vento)
                if (sprite_index != -1 && sprite_exists(sprite_index)) {
                    // Crea wind manager se necessario
                    create_wind_manager_if_needed();

                    if (shake_timer > 0) {
                        // Con shake: usa funzione specializzata per shake + vento
                        var shake_x = cos(shake_direction) * shake_intensity;
                        var shake_y = sin(shake_direction) * shake_intensity;

                        apply_tree_frame_wind_with_shake(sprite_index, x, y, "tree", id,
                                                        shake_x, shake_y, 1, 1, image_alpha);
                    } else {
                        // Solo vento: tronco fisso, foglie si muovono
                        apply_tree_frame_wind(sprite_index, x, y, "tree", id, 1, 1, image_alpha);
                    }
                }
            } else if (object_is_ancestor(object_index, obj_npc_base)) {
                // Draw NPCs (all inherit from obj_npc_base) - solo se sprite valido
                if (sprite_index != -1 && sprite_exists(sprite_index)) {
                    draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, image_alpha);
                }
                // NPC collision debug - yellow border
                draw_set_color(c_yellow);
                draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
                draw_set_color(c_white);
            } else {
                // Draw altri oggetti - solo se sprite valido
                if (sprite_index != -1 && sprite_exists(sprite_index)) {
                    draw_self();
                }
            }
        }
    
    }
    
    ds_grid_destroy(ds_depthgrid);
}
