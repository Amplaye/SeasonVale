// Variabili per effetto shake quando colpito
shake_timer = 0;
shake_intensity = 0;
shake_direction = 0;
last_hit_frame = -1;
hit_cooldown = 0;

// Sistema di salute e rilascio materiali
max_health = 10;  // Stessa resistenza degli alberi per consistenza
self.health = max_health;  // SELF per assicurarsi sia una variabile di istanza
hit_count = 0;
show_debug_message("🪨 Rock created with health: " + string(health) + "/" + string(max_health));
total_mining_drops = 5;  // 5 materiali totali durante mining (divisi su 10 colpi)
final_drops = 8;         // 8 materiali all'esplosione
is_dying = false;

// Variabili per cooldown danno
last_hit_time = 0;
last_damage_time = 0;