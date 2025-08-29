// ID dell'albero parent che deve diventare trasparente
  parent_tree = noone;

  // Trova l'albero più vicino e collegalo
  var nearest = instance_nearest(x, y, obj_tree);
  if (nearest != noone && point_distance(x, y, nearest.x, nearest.y) < 50) {
      parent_tree = nearest;
  }