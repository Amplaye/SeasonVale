// ===================================================================
// 🖥️ DISPLAY MANAGER - VERSIONE SEMPLIFICATA
// ===================================================================

// Singleton pattern - solo un display manager
if (instance_number(obj_display_manager) > 1) {
    instance_destroy();
    exit;
}

depth = -5000;
persistent = true;

// ===== CONFIGURAZIONE BASE =====
global.base_width = 480;
global.base_height = 270;

// ===== RILEVAMENTO DISPLAY =====
var display_w = display_get_width();
var display_h = display_get_height();

// ===== CALCOLO SCALING AUTOMATICO SEMPLIFICATO =====
var selected_scale = 3; // Default
var selected_name = "Auto";

// Rilevamento diretto per le risoluzioni più comuni
if (display_w == 2560 && display_h == 1664) {
    // MacBook Air M2 - scaling speciale per Retina
    selected_scale = 3; // Usiamo 3x invece di 4x per pixel perfect su Retina
    selected_name = "MacBook Air M2 Retina";
} else if (display_w == 1920 && display_h == 1080) {
    selected_scale = 3; // Full HD
    selected_name = "Full HD";
} else if (display_w == 2560 && display_h == 1440) {
    selected_scale = 4; // 1440p
    selected_name = "1440p Gaming";
} else if (display_w == 3840 && display_h == 2160) {
    selected_scale = 5; // 4K
    selected_name = "4K";
} else if (display_w == 1366 && display_h == 768) {
    selected_scale = 2; // HD Laptop
    selected_name = "HD Laptop";
} else if (display_w == 1280 && display_h == 800) {
    selected_scale = 2; // Steam Deck
    selected_name = "Steam Deck";
} else {
    // Calcolo automatico per altre risoluzioni
    var auto_scale_x = floor(display_w / global.base_width / 1.3);
    var auto_scale_y = floor(display_h / global.base_height / 1.3);
    selected_scale = min(auto_scale_x, auto_scale_y);
    selected_scale = clamp(selected_scale, 2, 5);
    selected_name = "Auto (" + string(selected_scale) + "x)";
}

// Applica scaling calcolato
global.optimal_scale = selected_scale;
global.window_width = global.base_width * selected_scale;
global.window_height = global.base_height * selected_scale;

// ===== GESTIONE FULLSCREEN =====
global.is_fullscreen = false;

// ===== FUNZIONE FULLSCREEN AVANZATA =====
function toggle_fullscreen() {
    global.is_fullscreen = !global.is_fullscreen;

    if (global.is_fullscreen) {
        // FULLSCREEN: Usa stesso scaling di windowed per qualità identica
        var fs_width = global.base_width * global.optimal_scale;
        var fs_height = global.base_height * global.optimal_scale;

        // Verifica che entri nello schermo, altrimenti riduci di 1
        var current_display_w = display_get_width();
        var current_display_h = display_get_height();

        if (fs_width > current_display_w || fs_height > current_display_h) {
            var reduced_scale = global.optimal_scale - 1;
            reduced_scale = max(reduced_scale, 2); // Minimo 2x
            fs_width = global.base_width * reduced_scale;
            fs_height = global.base_height * reduced_scale;
        }

        window_set_fullscreen(true);
        surface_resize(application_surface, fs_width, fs_height);

        show_debug_message("🖥️ Fullscreen: " + string(fs_width) + "x" + string(fs_height) + " (qualità identica)");
    } else {
        // WINDOWED: Torna alle dimensioni ottimali
        window_set_fullscreen(false);
        window_set_size(global.window_width, global.window_height);
        surface_resize(application_surface, global.window_width, global.window_height);

        // Centra la finestra
        var center_display_w = display_get_width();
        var center_display_h = display_get_height();
        window_set_position((center_display_w - global.window_width) / 2, (center_display_h - global.window_height) / 2);

        show_debug_message("🖥️ Windowed: " + string(global.window_width) + "x" + string(global.window_height));
    }
}

// ===== INIZIALIZZAZIONE CON PIXEL PERFECT MAC =====
gpu_set_tex_filter(false);

// Ottimizzazioni specifiche per Mac
if (os_type == os_macosx) {
    // Force tutti i filtri off per Mac
    gpu_set_tex_filter_ext(0, false);
    gpu_set_tex_filter_ext(1, false);

    show_debug_message("🍎 Ottimizzazioni Mac Retina applicate");
}

show_debug_message("🖥️ Display Manager inizializzato");
show_debug_message("🖥️ Display rilevato: " + string(display_w) + "x" + string(display_h) + " (" + selected_name + ")");
show_debug_message("🖥️ Scaling ottimale: " + string(selected_scale) + "x");
show_debug_message("🖥️ Risoluzione gioco: " + string(global.window_width) + "x" + string(global.window_height));