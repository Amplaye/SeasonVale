// Riduci cooldown hit
if (hit_cooldown > 0) {
    hit_cooldown--;
}

// Sistema mining detection
if (!is_dying) {
    var player = instance_find(obj_player, 0);
    if (player != noone && variable_instance_exists(player, "is_mining") && player.is_mining) {
        var dist_to_player = point_distance(x, y, player.x, player.y);
        
        // Controlla che il player abbia il piccone selezionato (tool slot 1)
        if (dist_to_player < 50 && hit_cooldown <= 0 && global.selected_tool == 1) {
            // Danneggia roccia - UN SOLO DANNO per colpo con cooldown
            health--;
            hit_count++;
            hit_cooldown = 18;  // 18 frame di cooldown tra i colpi (più lento del chopping)
            
            // Avvia shake (più intenso se poca vita)
            var health_ratio = health / max_health;
            shake_timer = 25;  // Shake più lungo per rocce
            shake_intensity = 1.5 + (1 - health_ratio) * 1.0;  // Shake più intenso
            shake_direction = random(2 * pi);
            
            // Rilascia materiali progressivamente con effetto fontana
            // Probabilità di drop: 6 materiali su 12 colpi = 50%
            if (random(100) < 50) {
                // Crea rock_drop con effetto fontana durante mining
                var drop = instance_create_depth(x, y - 40, depth - 10, obj_rock_drop);
                
                // Movimento fontana ridotto per mining
                drop.hspeed = random_range(-1.2, 1.2);
                drop.vspeed = random_range(-2, -0.8);  // Spinta verso l'alto ridotta (rocce più pesanti)
            }
            
            // Controlla se roccia è distrutta
            if (health <= 0) {
                is_dying = true;
                alarm[0] = 40;  // Delay più lungo prima dell'esplosione roccia
            }
        }
    }
}

// Gestione effetto shake quando colpito - roccia resta fissa
if (shake_timer > 0) {
    shake_timer--;
    
    // Riduci intensità progressivamente
    shake_intensity *= 0.82;  // Shake che dura di più
    
    // Cambia direzione per effetto oscillazione
    shake_direction += pi/5;  // Oscillazione più lenta
}