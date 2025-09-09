// Esplosione finale della roccia
// Rilascia 8 materiali roccia per esplosione finale
var num_final_drops = 8;

for (var i = 0; i < num_final_drops; i++) {
    var angle = random(360);
    var explosion_force = random_range(0.8, 2.0);  // Forza ridotta per rocce pesanti
    
    // Crea rock_drop con effetto fontana esplosione contenuta
    var drop = instance_create_depth(x, y - 40, depth - 10, obj_rock_drop);
    
    // EFFETTO FONTANA CONTENUTA: massimo 2 tiles di distanza (rocce più pesanti)
    drop.hspeed = lengthdir_x(explosion_force * 0.5, angle);  // Forza ridotta per rocce
    drop.vspeed = random_range(-2.5, -1);  // Spinta contenuta per rocce pesanti
    
    // Varia la gravità per effetto più naturale (rocce più pesanti)
    drop.gravity_acc = random_range(0.12, 0.25);
}

// Effetto particelle esplosione roccia (polvere)
repeat(15) {
    var px = x + random_range(-25, 25);
    var py = y - 30 + random_range(-25, 25);
    // Qui puoi aggiungere particelle di polvere se vuoi
}

// Distruggi la roccia
instance_destroy();