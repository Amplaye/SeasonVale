// ===================================================================
// 🌬️ WIND SYSTEM - FUNZIONI HELPER PER MOVIMENTO VENTO
// ===================================================================

/// @function get_wind_offset_x(profile_name, unique_offset)
/// @description Calcola l'offset X per il movimento del vento
/// @param {string} profile_name - Nome del profilo vento ("grass", "tree", etc.)
/// @param {real} unique_offset - Offset unico per questo oggetto (es. instance_id)
/// @return {real} Offset X in pixel
function get_wind_offset_x(profile_name, unique_offset = 0) {
    // Return 0 se vento disabilitato
    if (!variable_global_exists("wind_enabled") || !global.wind_enabled) {
        return 0;
    }

    // Assicurati che wind manager esista
    if (!instance_exists(obj_wind_manager)) {
        return 0;
    }

    // Ottieni profilo
    var profile = obj_wind_manager.get_wind_profile(profile_name);

    // Calcola tempo unico per questo oggetto
    var time_offset = real(unique_offset) * 0.01; // Converti a valore piccolo
    var unique_time = global.wind_time + time_offset;

    // Movimento base sinusoidale
    var base_movement = sin(unique_time * profile.frequency) * profile.amplitude;

    // Aggiungi variazione per rendere più naturale
    var variation = sin(unique_time * profile.frequency * 0.7 + real(unique_offset)) * (profile.amplitude * 0.3);

    // Influenza della direzione del vento
    var direction_factor = cos(degtorad(obj_wind_manager.wind_main_direction)) * profile.direction_influence;

    // Combina tutto
    var final_offset = (base_movement + variation) * profile.damping *
                      global.wind_global_intensity * obj_wind_manager.wind_current_intensity *
                      (1.0 + direction_factor);

    return final_offset;
}

/// @function get_wind_offset_y(profile_name, unique_offset)
/// @description Calcola l'offset Y per il movimento del vento (movimento verticale leggero)
/// @param {string} profile_name - Nome del profilo vento
/// @param {real} unique_offset - Offset unico per questo oggetto
/// @return {real} Offset Y in pixel
function get_wind_offset_y(profile_name, unique_offset = 0) {
    // Return 0 se vento disabilitato
    if (!variable_global_exists("wind_enabled") || !global.wind_enabled) {
        return 0;
    }

    // Assicurati che wind manager esista
    if (!instance_exists(obj_wind_manager)) {
        return 0;
    }

    // Ottieni profilo
    var profile = obj_wind_manager.get_wind_profile(profile_name);

    // Calcola tempo unico
    var time_offset = real(unique_offset) * 0.01;
    var unique_time = global.wind_time + time_offset;

    // Movimento verticale più sottile (30% dell'ampiezza orizzontale)
    var vertical_amplitude = profile.amplitude * 0.3;

    // Movimento base con frequenza diversa per varietà
    var base_movement = sin(unique_time * profile.frequency * 1.3) * vertical_amplitude;

    // Variazione più sottile
    var variation = cos(unique_time * profile.frequency * 0.9 + real(unique_offset) * 2) * (vertical_amplitude * 0.2);

    // Influenza direzione del vento (componente Y)
    var direction_factor = sin(degtorad(obj_wind_manager.wind_main_direction)) * profile.direction_influence * 0.5;

    // Combina tutto
    var final_offset = (base_movement + variation) * profile.damping *
                      global.wind_global_intensity * obj_wind_manager.wind_current_intensity *
                      (1.0 + direction_factor);

    return final_offset;
}

/// @function get_wind_rotation(profile_name, unique_offset)
/// @description Calcola rotazione per il movimento del vento (per oggetti che possono ruotare)
/// @param {string} profile_name - Nome del profilo vento
/// @param {real} unique_offset - Offset unico per questo oggetto
/// @return {real} Rotazione in gradi
function get_wind_rotation(profile_name, unique_offset = 0) {
    // Return 0 se vento disabilitato
    if (!variable_global_exists("wind_enabled") || !global.wind_enabled) {
        return 0;
    }

    // Assicurati che wind manager esista
    if (!instance_exists(obj_wind_manager)) {
        return 0;
    }

    // Ottieni profilo
    var profile = obj_wind_manager.get_wind_profile(profile_name);

    // Calcola tempo unico
    var time_offset = real(unique_offset) * 0.01;
    var unique_time = global.wind_time + time_offset;

    // Rotazione basata sull'ampiezza ma più sottile
    var rotation_amplitude = profile.amplitude * 0.5; // Max rotazione in gradi

    // Movimento rotazionale
    var base_rotation = sin(unique_time * profile.frequency * 0.8) * rotation_amplitude;

    // Variazione
    var variation = cos(unique_time * profile.frequency * 1.1 + real(unique_offset)) * (rotation_amplitude * 0.3);

    // Influenza direzione del vento
    var direction_influence = obj_wind_manager.wind_main_direction * profile.direction_influence * 0.1;

    // Combina tutto
    var final_rotation = (base_rotation + variation + direction_influence) * profile.damping *
                        global.wind_global_intensity * obj_wind_manager.wind_current_intensity;

    return final_rotation;
}

/// @function apply_wind_to_sprite(sprite_id, x, y, profile_name, unique_offset)
/// @description Disegna uno sprite con movimento di vento applicato
/// @param {asset.GMSprite} sprite_id - Sprite da disegnare
/// @param {real} x - Posizione X base
/// @param {real} y - Posizione Y base
/// @param {string} profile_name - Nome del profilo vento
/// @param {real} unique_offset - Offset unico (opzionale, default instance_id se disponibile)
/// @param {real} scale_x - Scala X (opzionale, default 1)
/// @param {real} scale_y - Scala Y (opzionale, default 1)
/// @param {real} alpha - Alpha (opzionale, default 1)
function apply_wind_to_sprite(sprite_id, x, y, profile_name, unique_offset = -1,
                             scale_x = 1, scale_y = 1, alpha = 1) {

    // Usa instance_id come offset se non specificato
    if (unique_offset == -1) {
        unique_offset = (variable_instance_exists(id, "id")) ? id : irandom(10000);
    }

    // Calcola offset vento
    var wind_x = get_wind_offset_x(profile_name, unique_offset);
    var wind_y = get_wind_offset_y(profile_name, unique_offset);
    var wind_rotation = get_wind_rotation(profile_name, unique_offset);

    // Disegna sprite con movimento applicato
    draw_sprite_ext(sprite_id, 0, x + wind_x, y + wind_y,
                   scale_x, scale_y, wind_rotation, c_white, alpha);
}

/// @function apply_wind_deformation(sprite_id, x, y, profile_name, unique_offset)
/// @description Disegna sprite con deformazione realistica (piegamento dalla base)
/// @param {asset.GMSprite} sprite_id - Sprite da disegnare
/// @param {real} x - Posizione X base
/// @param {real} y - Posizione Y base
/// @param {string} profile_name - Nome del profilo vento
/// @param {real} unique_offset - Offset unico (opzionale, default instance_id)
/// @param {real} scale_x - Scala X (opzionale, default 1)
/// @param {real} scale_y - Scala Y (opzionale, default 1)
/// @param {real} alpha - Alpha (opzionale, default 1)
function apply_wind_deformation(sprite_id, x, y, profile_name, unique_offset = -1,
                               scale_x = 1, scale_y = 1, alpha = 1) {

    // Return se vento disabilitato
    if (!variable_global_exists("wind_enabled") || !global.wind_enabled) {
        draw_sprite_ext(sprite_id, 0, x, y, scale_x, scale_y, 0, c_white, alpha);
        return;
    }

    // Usa instance_id come offset se non specificato
    if (unique_offset == -1) {
        unique_offset = (variable_instance_exists(id, "id")) ? id : irandom(10000);
    }

    // Calcola movimento vento
    var wind_x = get_wind_offset_x(profile_name, unique_offset);
    var wind_y = get_wind_offset_y(profile_name, unique_offset);

    // Calcolo tempo per deformazione naturale
    var time = global.wind_time + real(unique_offset) * 0.01;
    var time_offset = cos(time * 2 + x / 50 + y / 50) *
                     global.wind_global_intensity *
                     (instance_exists(obj_wind_manager) ? obj_wind_manager.wind_current_intensity : 1.0);

    // Combina movimento per naturalezza
    var total_offset_x = (wind_x * 0.7) + (time_offset * 0.3);
    var total_offset_y = wind_y * 0.5;

    // Setup sprite deformation
    var uvs = sprite_get_uvs(sprite_id, 0);
    var sprite_w = sprite_get_width(sprite_id) * scale_x;
    var sprite_h = sprite_get_height(sprite_id) * scale_y;
    var sprite_xoff = sprite_get_xoffset(sprite_id) * scale_x;
    var sprite_yoff = sprite_get_yoffset(sprite_id) * scale_y;

    var crop_left = uvs[4] * scale_x;
    var crop_top = uvs[5] * scale_y;
    var crop_right = sprite_w - (uvs[6] * sprite_w) - crop_left;
    var crop_bottom = sprite_h - (uvs[7] * sprite_h) - crop_top;

    // 4 punti per deformazione: top si muove, bottom fisso
    var x1 = x - sprite_xoff + total_offset_x + crop_left;           // Top-left
    var y1 = y - sprite_yoff + total_offset_y + crop_top;

    var x2 = x - sprite_xoff + sprite_w + total_offset_x - crop_right; // Top-right
    var y2 = y - sprite_yoff + total_offset_y + crop_top;

    var x3 = x - sprite_xoff + sprite_w - crop_right;                // Bottom-right
    var y3 = y - sprite_yoff + sprite_h - crop_bottom;

    var x4 = x - sprite_xoff + crop_left;                           // Bottom-left
    var y4 = y - sprite_yoff + sprite_h - crop_bottom;

    // Disegna con deformazione
    draw_sprite_pos(sprite_id, 0, x1, y1, x2, y2, x3, y3, x4, y4, alpha);
}

/// @function apply_partial_wind_deformation(sprite_id, x, y, profile_name, unique_offset, deformation_height)
/// @description Disegna sprite con deformazione parziale (solo parte superiore si muove)
/// @param {asset.GMSprite} sprite_id - Sprite da disegnare
/// @param {real} x - Posizione X base
/// @param {real} y - Posizione Y base
/// @param {string} profile_name - Nome del profilo vento
/// @param {real} unique_offset - Offset unico
/// @param {real} deformation_height - Percentuale altezza che si deforma (0.0-1.0, es. 0.6 = top 60%)
/// @param {real} scale_x - Scala X (opzionale, default 1)
/// @param {real} scale_y - Scala Y (opzionale, default 1)
/// @param {real} alpha - Alpha (opzionale, default 1)
function apply_partial_wind_deformation(sprite_id, x, y, profile_name, unique_offset = -1,
                                       deformation_height = 0.6, scale_x = 1, scale_y = 1, alpha = 1) {

    // Return se vento disabilitato
    if (!variable_global_exists("wind_enabled") || !global.wind_enabled) {
        draw_sprite_ext(sprite_id, 0, x, y, scale_x, scale_y, 0, c_white, alpha);
        return;
    }

    // Usa instance_id come offset se non specificato
    if (unique_offset == -1) {
        unique_offset = (variable_instance_exists(id, "id")) ? id : irandom(10000);
    }

    // Calcola movimento vento
    var wind_x = get_wind_offset_x(profile_name, unique_offset);
    var wind_y = get_wind_offset_y(profile_name, unique_offset);

    // Calcolo tempo per movimento naturale
    var time = global.wind_time + real(unique_offset) * 0.01;
    var time_offset = cos(time * 1.5 + x / 60 + y / 60) *
                     global.wind_global_intensity *
                     (instance_exists(obj_wind_manager) ? obj_wind_manager.wind_current_intensity : 1.0);

    // Combina movimento per naturalezza (ridotto per alberi)
    var total_offset_x = (wind_x * 0.5) + (time_offset * 0.2);
    var total_offset_y = wind_y * 0.3;

    // Setup sprite dimensions
    var sprite_w = sprite_get_width(sprite_id) * scale_x;
    var sprite_h = sprite_get_height(sprite_id) * scale_y;
    var sprite_xoff = sprite_get_xoffset(sprite_id) * scale_x;
    var sprite_yoff = sprite_get_yoffset(sprite_id) * scale_y;

    // Calcola punto di separazione (dove inizia la deformazione)
    var separation_point = sprite_h * (1.0 - deformation_height);

    // ===== PARTE INFERIORE (TRONCO) - FISSA =====
    if (separation_point > 0) {
        // Disegna parte inferiore statica
        var bottom_x1 = x - sprite_xoff;
        var bottom_y1 = y - sprite_yoff + separation_point;
        var bottom_x2 = x - sprite_xoff + sprite_w;
        var bottom_y2 = y - sprite_yoff + separation_point;
        var bottom_x3 = x - sprite_xoff + sprite_w;
        var bottom_y3 = y - sprite_yoff + sprite_h;
        var bottom_x4 = x - sprite_xoff;
        var bottom_y4 = y - sprite_yoff + sprite_h;

        // UV coordinates per parte inferiore
        var uv_top = separation_point / sprite_h;

        draw_sprite_part_ext(sprite_id, 0,
                           0, separation_point,
                           sprite_get_width(sprite_id), sprite_get_height(sprite_id) - separation_point,
                           x - sprite_xoff, y - sprite_yoff + separation_point,
                           scale_x, scale_y, c_white, alpha);
    }

    // ===== PARTE SUPERIORE (FOGLIE) - CON DEFORMAZIONE =====
    if (deformation_height > 0) {
        // 4 punti per deformazione della parte superiore
        var top_x1 = x - sprite_xoff + total_offset_x;           // Top-left (con movimento)
        var top_y1 = y - sprite_yoff + total_offset_y;

        var top_x2 = x - sprite_xoff + sprite_w + total_offset_x; // Top-right (con movimento)
        var top_y2 = y - sprite_yoff + total_offset_y;

        var top_x3 = x - sprite_xoff + sprite_w;                 // Separation-right (fisso)
        var top_y3 = y - sprite_yoff + separation_point;

        var top_x4 = x - sprite_xoff;                           // Separation-left (fisso)
        var top_y4 = y - sprite_yoff + separation_point;

        // Disegna parte superiore con deformazione usando draw_sprite_pos
        var uvs = sprite_get_uvs(sprite_id, 0);
        var uv_left = uvs[0];
        var uv_top = uvs[1];
        var uv_right = uvs[2];
        var uv_bottom = uvs[1] + ((uvs[3] - uvs[1]) * deformation_height);

        // Disegna parte superiore deformata
        draw_sprite_part_ext(sprite_id, 0,
                           0, 0,
                           sprite_get_width(sprite_id), separation_point,
                           top_x1, top_y1,
                           scale_x, scale_y, c_white, alpha);
    }
}

/// @function apply_tree_frame_wind(sprite_id, x, y, profile_name, unique_offset)
/// @description Disegna albero con frame separati: frame 0 (tronco fisso) + frame 1 (foglie con vento)
/// @param {asset.GMSprite} sprite_id - Sprite dell'albero (frame 0=tronco, frame 1=foglie)
/// @param {real} x - Posizione X base
/// @param {real} y - Posizione Y base
/// @param {string} profile_name - Nome del profilo vento
/// @param {real} unique_offset - Offset unico (opzionale, default instance_id)
/// @param {real} scale_x - Scala X (opzionale, default 1)
/// @param {real} scale_y - Scala Y (opzionale, default 1)
/// @param {real} alpha - Alpha (opzionale, default 1)
function apply_tree_frame_wind(sprite_id, x, y, profile_name, unique_offset = -1,
                              scale_x = 1, scale_y = 1, alpha = 1) {

    // Usa instance_id come offset se non specificato
    if (unique_offset == -1) {
        unique_offset = (variable_instance_exists(id, "id")) ? id : irandom(10000);
    }

    // 1. DISEGNA TRONCO (FRAME 0) - SEMPRE FISSO
    draw_sprite_ext(sprite_id, 0, x, y, scale_x, scale_y, 0, c_white, alpha);

    // 2. DISEGNA FOGLIE (FRAME 1) - CON MOVIMENTO VENTO
    if (!variable_global_exists("wind_enabled") || !global.wind_enabled) {
        // Se vento disabilitato, disegna foglie fisse
        draw_sprite_ext(sprite_id, 1, x, y, scale_x, scale_y, 0, c_white, alpha);
    } else {
        // Calcola movimento vento per le foglie
        var wind_x = get_wind_offset_x(profile_name, unique_offset);
        var wind_y = get_wind_offset_y(profile_name, unique_offset);
        var wind_rotation = get_wind_rotation(profile_name, unique_offset);

        // Disegna foglie con movimento vento
        draw_sprite_ext(sprite_id, 1, x + wind_x, y + wind_y,
                       scale_x, scale_y, wind_rotation, c_white, alpha);
    }
}

/// @function apply_tree_frame_wind_with_shake(sprite_id, x, y, profile_name, unique_offset, shake_x, shake_y)
/// @description Versione con shake per quando l'albero viene colpito
/// @param {asset.GMSprite} sprite_id - Sprite dell'albero
/// @param {real} x - Posizione X base
/// @param {real} y - Posizione Y base
/// @param {string} profile_name - Nome del profilo vento
/// @param {real} unique_offset - Offset unico
/// @param {real} shake_x - Offset shake X
/// @param {real} shake_y - Offset shake Y
/// @param {real} scale_x - Scala X (opzionale, default 1)
/// @param {real} scale_y - Scala Y (opzionale, default 1)
/// @param {real} alpha - Alpha (opzionale, default 1)
function apply_tree_frame_wind_with_shake(sprite_id, x, y, profile_name, unique_offset,
                                         shake_x, shake_y, scale_x = 1, scale_y = 1, alpha = 1) {

    // 1. DISEGNA TRONCO (FRAME 0) - CON SHAKE
    draw_sprite_ext(sprite_id, 0, x + shake_x, y + shake_y, scale_x, scale_y, 0, c_white, alpha);

    // 2. DISEGNA FOGLIE (FRAME 1) - CON SHAKE + VENTO
    if (!variable_global_exists("wind_enabled") || !global.wind_enabled) {
        // Solo shake se vento disabilitato
        draw_sprite_ext(sprite_id, 1, x + shake_x, y + shake_y, scale_x, scale_y, 0, c_white, alpha);
    } else {
        // Calcola movimento vento
        var wind_x = get_wind_offset_x(profile_name, unique_offset);
        var wind_y = get_wind_offset_y(profile_name, unique_offset);
        var wind_rotation = get_wind_rotation(profile_name, unique_offset);

        // Combina shake + vento per le foglie
        draw_sprite_ext(sprite_id, 1,
                       x + shake_x + wind_x, y + shake_y + wind_y,
                       scale_x, scale_y, wind_rotation, c_white, alpha);
    }
}

/// @function create_wind_manager_if_needed()
/// @description Crea wind manager se non esiste (utility function)
function create_wind_manager_if_needed() {
    if (!instance_exists(obj_wind_manager)) {
        instance_create_layer(0, 0, "Instances", obj_wind_manager);
        show_debug_message("🌬️ Wind Manager creato automaticamente");
    }
}