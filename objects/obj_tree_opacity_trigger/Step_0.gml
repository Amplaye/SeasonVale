// Controlla collisione con player per opacità
if (parent_tree != noone && instance_exists(parent_tree)) {
    // Verifica se il player è nell'area del trigger
    var player = instance_find(obj_player, 0);
    
    if (player != noone) {
        var player_in_area = (player.x >= bbox_left && player.x <= bbox_right && 
                             player.y >= bbox_top && player.y <= bbox_bottom);
        
        if (player_in_area) {
            // Player nell'area - rendi trasparente
            if (parent_tree.image_alpha > 0.3) {
                parent_tree.image_alpha = max(0.3, parent_tree.image_alpha - 0.1);
                if (abs(parent_tree.image_alpha - 0.3) < 0.01) {
                    parent_tree.image_alpha = 0.3;
                    // Debug: albero trasparente
                }
            }
        } else {
            // Player fuori dall'area - ripristina opacità
            if (parent_tree.image_alpha < 1.0) {
                parent_tree.image_alpha = min(1.0, parent_tree.image_alpha + 0.1);
                if (abs(parent_tree.image_alpha - 1.0) < 0.01) {
                    parent_tree.image_alpha = 1.0;
                    // Debug: albero opaco
                }
            }
        }
    }
}