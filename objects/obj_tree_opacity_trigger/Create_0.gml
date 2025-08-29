// ID dell'albero parent che deve diventare trasparente
parent_tree = noone;

// Trova l'albero più vicino e collegalo (range 100px)
var nearest = instance_nearest(x, y, obj_tree);
if (nearest != noone) {
    var dist = point_distance(x, y, nearest.x, nearest.y);
    if (dist < 100) {
        parent_tree = nearest;
    }
}