// Riduci cooldown hit
if (hit_cooldown > 0) {
    hit_cooldown--;
}

// Sistema chopping detection
if (!is_dying) {
    var player = instance_find(obj_player, 0);
    if (player != noone && variable_instance_exists(player, "is_chopping") && player.is_chopping) {
        var dist_to_player = point_distance(x, y, player.x, player.y);
        
        // Controlla che il player abbia l'ascia selezionata (tool slot 0)
        if (dist_to_player < 50 && hit_cooldown <= 0 && global.selected_tool == 0) {
            // Danneggia albero - UN SOLO DANNO per colpo con cooldown
            health--;
            hit_count++;
            hit_cooldown = 15;  // 15 frame di cooldown tra i colpi
            
            // Avvia shake (più intenso se poca vita)
            var health_ratio = health / max_health;
            shake_timer = 20;
            shake_intensity = 1.2 + (1 - health_ratio) * 0.8;
            shake_direction = random(2 * pi);
            
            // Rilascia materiali progressivamente con effetto fontana
            // Probabilità di drop: 5 materiali su 10 colpi = 50%
            if (random(100) < 50) {
                // Crea wood_drop con effetto fontana durante chopping
                var drop = instance_create_depth(x, y - 60, depth - 10, obj_wood_drop);
                
                // Movimento fontana ridotto per chopping
                drop.hspeed = random_range(-1.5, 1.5);
                drop.vspeed = random_range(-2.5, -1);  // Spinta verso l'alto ridotta
            }
            
            // Controlla se albero è morto
            if (health <= 0) {
                is_dying = true;
                alarm[0] = 30;  // Delay prima dell'esplosione
            }
        }
    }
}

// Gestione effetto shake quando colpito - albero resta fisso
if (shake_timer > 0) {
    shake_timer--;
    
    // Riduci intensità progressivamente
    shake_intensity *= 0.85;
    
    // Cambia direzione per effetto oscillazione
    shake_direction += pi/4;
}

