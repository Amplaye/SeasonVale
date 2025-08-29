// Fisica per effetto fontana ridotta del 50%
vspeed = 0;
hspeed = 0;
gravity_acc = 0.15;
ground_y = y + 40;  // Livello del suolo
has_bounced = false;

// Inizializza movimento (sarà impostato dall'albero)
// vspeed negativo = verso l'alto
// hspeed = movimento laterale