// ===================================================================
// 🖥️ DISPLAY MANAGER - GESTIONE QUALITÀ GRAFICA E SCALING
// ===================================================================

// Singleton pattern - solo un display manager
if (instance_number(obj_display_manager) > 1) {
    instance_destroy();
    exit;
}

depth = -5000; // Display manager - layer sistema
persistent = true; // Mantieni tra le room

// ===== CONFIGURAZIONE BASE =====
// Risoluzione nativa del gioco (camera size)
global.base_width = 480;
global.base_height = 270;

// Risoluzione finestra predefinita (2x scaling perfetto)
global.window_width = 960;
global.window_height = 540;

// ===== IMPOSTAZIONI QUALITÀ =====
// Disabilita interpolazione per pixel art crisp
gpu_set_tex_filter(false);

// Imposta scaling nearest neighbor per mantenere pixel perfetti
// display_set_gui_size(global.base_width, global.base_height); // Commentato per evitare scaling del cursor

// ===== GESTIONE FULLSCREEN =====
global.is_fullscreen = false;
global.target_fps = 60;

// Salva le dimensioni originali della finestra
global.windowed_width = global.window_width;
global.windowed_height = global.window_height;

// ===== FUNZIONI UTILITY =====

/// @function toggle_fullscreen()
/// @description Alterna tra fullscreen e windowed mode
function toggle_fullscreen() {
    global.is_fullscreen = !global.is_fullscreen;

    if (global.is_fullscreen) {
        // Vai in fullscreen con scaling perfetto
        var display_w = display_get_width();
        var display_h = display_get_height();

        // Calcola il miglior scaling mantenendo proporzioni
        var scale_x = floor(display_w / global.base_width);
        var scale_y = floor(display_h / global.base_height);
        var scale = min(scale_x, scale_y);

        // Assicurati che lo scale sia almeno 1
        scale = max(scale, 1);

        // Calcola dimensioni finali centrate
        var final_w = global.base_width * scale;
        var final_h = global.base_height * scale;

        window_set_fullscreen(true);
        surface_resize(application_surface, final_w, final_h);

        show_debug_message("🖥️ Fullscreen attivato: " + string(final_w) + "x" + string(final_h) + " (scale: " + string(scale) + "x)");
    } else {
        // Torna in windowed mode
        window_set_fullscreen(false);
        window_set_size(global.windowed_width, global.windowed_height);
        surface_resize(application_surface, global.windowed_width, global.windowed_height);

        // Centra la finestra
        var display_w = display_get_width();
        var display_h = display_get_height();
        window_set_position((display_w - global.windowed_width) / 2, (display_h - global.windowed_height) / 2);

        show_debug_message("🖥️ Windowed mode attivato: " + string(global.windowed_width) + "x" + string(global.windowed_height));
    }
}

/// @function set_display_quality(quality_level)
/// @description Imposta il livello di qualità (1-4, dove 4 è la massima)
/// @param {real} quality_level - Livello qualità da 1 a 4
function set_display_quality(quality_level) {
    quality_level = clamp(quality_level, 1, 4);

    switch (quality_level) {
        case 1: // Bassa qualità - 1x scaling
            global.window_width = global.base_width;
            global.window_height = global.base_height;
            break;

        case 2: // Media qualità - 2x scaling
            global.window_width = global.base_width * 2;
            global.window_height = global.base_height * 2;
            break;

        case 3: // Alta qualità - 3x scaling
            global.window_width = global.base_width * 3;
            global.window_height = global.base_height * 3;
            break;

        case 4: // Massima qualità - 4x scaling
            global.window_width = global.base_width * 4;
            global.window_height = global.base_height * 4;
            break;
    }

    if (!global.is_fullscreen) {
        window_set_size(global.window_width, global.window_height);
        surface_resize(application_surface, global.window_width, global.window_height);
    }

    show_debug_message("🖥️ Qualità impostata: Livello " + string(quality_level) + " (" + string(global.window_width) + "x" + string(global.window_height) + ")");
}

/// @function perfect_pixel_setup()
/// @description Configurazione ottimale per pixel art
function perfect_pixel_setup() {
    // Disabilita texture filtering
    gpu_set_tex_filter(false);

    // NON cambiare GUI size - lascia la dimensione della finestra
    // display_set_gui_size(global.base_width, global.base_height);

    // Assicura che il surface sia delle dimensioni corrette
    if (!global.is_fullscreen) {
        surface_resize(application_surface, global.window_width, global.window_height);
    }
}

/// @function fix_pixel_perfect()
/// @description Forza il setup pixel perfect corretto
function fix_pixel_perfect() {
    show_debug_message("🔧 Fixing pixel perfect setup...");

    // Force texture filtering off
    gpu_set_tex_filter(false);
    gpu_set_tex_filter_ext(0, false);
    gpu_set_tex_filter_ext(1, false);

    // NON resettare GUI size - mantieni dimensioni finestra
    // display_set_gui_size(global.base_width, global.base_height);

    if (global.is_fullscreen) {
        // Ricalcola fullscreen perfetto
        var display_w = display_get_width();
        var display_h = display_get_height();

        // Trova il più grande scaling intero che entra nello schermo
        var scale_x = floor(display_w / global.base_width);
        var scale_y = floor(display_h / global.base_height);
        var scale = min(scale_x, scale_y);
        scale = max(scale, 1); // Minimo 1x

        // Applica il nuovo surface con dimensioni perfette
        var final_w = global.base_width * scale;
        var final_h = global.base_height * scale;

        surface_resize(application_surface, final_w, final_h);

        show_debug_message("🔧 Fixed fullscreen: " + string(final_w) + "x" + string(final_h) + " (scale: " + string(scale) + "x)");
    } else {
        // Fix windowed mode
        surface_resize(application_surface, global.window_width, global.window_height);
        window_set_size(global.window_width, global.window_height);

        show_debug_message("🔧 Fixed windowed: " + string(global.window_width) + "x" + string(global.window_height));
    }
}

// ===== INIZIALIZZAZIONE =====
perfect_pixel_setup();
set_display_quality(2); // Inizia con qualità media (2x)

show_debug_message("🖥️ Display Manager inizializzato");
show_debug_message("🖥️ Risoluzione base: " + string(global.base_width) + "x" + string(global.base_height));
show_debug_message("🖥️ Risoluzione finestra: " + string(global.window_width) + "x" + string(global.window_height));
show_debug_message("🖥️ Texture filtering: DISABILITATO (pixel perfect)");