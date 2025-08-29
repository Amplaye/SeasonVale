// Variabili per effetto shake quando colpito
shake_timer = 0;
shake_intensity = 0;
shake_direction = 0;
last_hit_frame = -1;
hit_cooldown = 0;

// Sistema di salute e rilascio materiali
max_health = 10;
health = max_health;
hit_count = 0;
total_chopping_drops = 5;  // 5 materiali totali durante chopping (divisi su 10 colpi)
final_drops = 10;          // 10 materiali all'esplosione
is_dying = false;