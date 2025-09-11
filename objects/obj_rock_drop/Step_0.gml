// Applica gravità
vspeed += gravity_acc;

// Perdita energia continua per stop naturale
if (abs(vspeed) > 0) vspeed *= (1 - energy_loss);
if (abs(hspeed) > 0) hspeed *= (1 - energy_loss);

// Controlla se tocca il suolo per rimbalzare
if (y >= ground_y && vspeed > 0) {
    y = ground_y;
    
    if (bounce_count < max_bounces) {
        // Applica rimbalzo con forza decrescente
        var current_bounce_strength = bounce_strength[bounce_count];
        vspeed = -abs(vspeed) * current_bounce_strength;  // Rimbalzo verso l'alto
        hspeed *= friction_horizontal;  // Attrito orizzontale
        bounce_count++;
    } else {
        // Continua a rimbalzare ma con perdita energia naturale
        vspeed = -abs(vspeed) * 0.1;  // Rimbalzi molto piccoli
        hspeed *= 0.8;  // Attrito maggiore
    }
}

// Stop naturale quando energia è quasi zero
if (abs(vspeed) < 0.1 && abs(hspeed) < 0.1 && y >= ground_y) {
    vspeed = 0;
    hspeed = 0;
    y = ground_y;
    
    // Crea sprite rock nel layer pickupable
    var rock_sprite = layer_sprite_create("pickupable", x, y, spr_rock);
    layer_sprite_xscale(rock_sprite, 0.5);
    layer_sprite_yscale(rock_sprite, 0.5);
    
    // Distruggi questo oggetto
    instance_destroy();
}

// Rotazione durante il volo (più naturale)
if (abs(vspeed) > 0.05 || abs(hspeed) > 0.05) {
    image_angle += hspeed * 1.5;
}