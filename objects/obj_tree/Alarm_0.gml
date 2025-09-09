// Esplosione finale dell'albero
// Rilascia 10 materiali con quantità x1, x2 o x3 per totale ~25 unità
var num_final_drops = 10;

for (var i = 0; i < num_final_drops; i++) {
    var angle = random(360);
    var explosion_force = random_range(1, 2.5);  // Forza molto ridotta (max 3 tile)
    
    // Crea wood_drop con effetto fontana esplosione contenuta
    var drop = instance_create_depth(x, y - 60, depth - 10, obj_wood_drop);
    
    // EFFETTO FONTANA CONTENUTA: massimo 2 tiles di distanza
    drop.hspeed = lengthdir_x(explosion_force * 0.6, angle);  // Forza ridotta per max 2 tiles
    drop.vspeed = random_range(-3, -1.5);  // Spinta contenuta
    
    // Varia la gravità ridotta per effetto più naturale
    drop.gravity_acc = random_range(0.1, 0.2);
}

// Effetto particelle esplosione (opzionale)
repeat(20) {
    var px = x + random_range(-20, 20);
    var py = y - 50 + random_range(-20, 20);
    // Qui puoi aggiungere particelle se vuoi
}

// Distruggi l'albero
instance_destroy();