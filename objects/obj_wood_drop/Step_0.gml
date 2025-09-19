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
    
    // Crea sprite wood nel layer appropriato
    var target_layer = "pickupable";
    if (!layer_exists(target_layer)) {
        // Se il layer non esiste, usa "Instances" o crealo
        if (layer_exists("Instances")) {
            target_layer = "Instances";
        } else if (layer_exists("World")) {
            target_layer = "World";
        } else {
            // Crea il layer se non esiste
            target_layer = layer_create(-500, "pickupable");
        }
    }

    var wood_sprite = layer_sprite_create(target_layer, x, y, spr_wood);
    layer_sprite_xscale(wood_sprite, 0.2);
    layer_sprite_yscale(wood_sprite, 0.2);
    
    // Distruggi questo oggetto
    instance_destroy();
}

// Rotazione durante il volo (più naturale)
if (abs(vspeed) > 0.05 || abs(hspeed) > 0.05) {
    image_angle += hspeed * 1.5;
}