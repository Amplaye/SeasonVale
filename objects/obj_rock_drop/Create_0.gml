// Sistema multi-rimbalzo naturale per rocce
vspeed = 0;
hspeed = 0;
gravity_acc = 0.15;
ground_y = y + 40;  // Livello del suolo

// Sistema rimbalzi multipli con energia decrescente
bounce_count = 0;
max_bounces = 3;
bounce_strength = [0.5, 0.3, 0.15];  // Forza ridotta per ogni rimbalzo
friction_horizontal = 0.85;  // Attrito orizzontale
energy_loss = 0.02;  // Perdita energia continua per stop naturale

// Movimento iniziale (sarà impostato dalla roccia)