// Variabili per effetto shake quando colpito
shake_timer = 0;
shake_intensity = 0;
shake_direction = 0;
last_hit_frame = -1;
hit_cooldown = 0;

// Sistema di salute e rilascio materiali
max_health = 12;  // Rocce più resistenti degli alberi
health = max_health;
hit_count = 0;
total_mining_drops = 6;  // 6 materiali totali durante mining (divisi su 12 colpi)
final_drops = 8;         // 8 materiali all'esplosione
is_dying = false;