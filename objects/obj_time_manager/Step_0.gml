// Skip giorno con F
if (keyboard_check_pressed(ord("F"))) {
    advance_day();
}

// BOTTONI TEST TEMPO (da rimuovere dopo i test)
// T = avanza 1 ora
if (keyboard_check_pressed(ord("T"))) {
    advance_hour();
}

// Y = avanza 30 minuti  
if (keyboard_check_pressed(ord("Y"))) {
    global.game_minute += 30;
    if (global.game_minute >= 60) {
        global.game_minute -= 60;
        advance_hour();
    }
    // show_debug_message("⏰ +30min - Time: " + format_time());
}

// U key removed - time is now always continuous

// Avanzamento automatico tempo (sempre attivo)
if (auto_advance) {
    time_timer += 1/60;  // Delta time in secondi
    
    if (time_timer >= time_speed) {
        time_timer = 0;
        global.game_minute++;
        
        if (global.game_minute >= minutes_per_hour) {
            global.game_minute = 0;
            advance_hour();
        } else {
            // show_debug_message("⏰ Time: " + format_time());
        }
    }
}