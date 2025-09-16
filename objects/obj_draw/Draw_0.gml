/// @description Draw Instances in Grid

if(ds_exists(ds_depthgrid, ds_type_grid)){

    //sort the grid by Y value (lowest Y values first)
    ds_grid_sort(ds_depthgrid, 1, true);
    
    //draw all of the instances in order (lowest Y value first)
    for(var yy = 0; yy < ds_grid_height(ds_depthgrid); yy += 1){
        
        //draw the instance
        var instanceID = ds_depthgrid[# 0, yy];
        
        with(instanceID){
            // Usa funzioni personalizzate per oggetti specifici
            if (object_index == obj_player) {
                draw_player_with_clothes();
            } else if (object_index == obj_rock) {
                // Draw rock with shake effect
                if (shake_timer > 0) {
                    var shake_x = cos(shake_direction) * shake_intensity;
                    var shake_y = sin(shake_direction) * shake_intensity;
                    draw_sprite_ext(sprite_index, image_index, x + shake_x, y + shake_y, 1, 1, 0, c_white, image_alpha);
                } else {
                    draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, image_alpha);
                }
            } else if (object_index == obj_tree) {
                // Draw tree with shake effect (same as rock)
                if (shake_timer > 0) {
                    var shake_x = cos(shake_direction) * shake_intensity;
                    var shake_y = sin(shake_direction) * shake_intensity;
                    draw_sprite_ext(sprite_index, image_index, x + shake_x, y + shake_y, 1, 1, 0, c_white, image_alpha);
                } else {
                    draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, image_alpha);
                }
            } else {
                draw_self();
            }
        }
    
    }
    
    ds_grid_destroy(ds_depthgrid);
}
