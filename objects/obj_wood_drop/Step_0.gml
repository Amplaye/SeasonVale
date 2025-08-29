// Applica gravità
vspeed += gravity_acc;

// Controlla se tocca il suolo
if (y >= ground_y && !has_bounced) {
    y = ground_y;
    vspeed *= -0.5;  // Rimbalzo
    hspeed *= 0.7;   // Frizione orizzontale
    has_bounced = true;
    
    // Crea sprite wood nel layer pickupable quando si ferma
    var wood_sprite = layer_sprite_create("pickupable", x, y, wood);
    layer_sprite_xscale(wood_sprite, 0.2);
    layer_sprite_yscale(wood_sprite, 0.2);
    
    // Distruggi questo oggetto fisico
    instance_destroy();
}

// Rotazione durante il volo
image_angle += hspeed * 2;