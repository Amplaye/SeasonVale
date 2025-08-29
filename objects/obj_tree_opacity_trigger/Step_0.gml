  // Controlla se player è uscito dall'area
  if (parent_tree != noone && instance_exists(parent_tree)) {
      if (!place_meeting(x, y, obj_player)) {
          parent_tree.image_alpha = 1.0;
      }
  }