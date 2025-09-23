// Singleton pattern - solo un font manager
if (instance_number(obj_font_manager) > 1) {
    instance_destroy();
    exit;
}

depth = -4000; // Font manager - layer più alto per gestione globale
persistent = true; // Mantieni tra le room

show_debug_message("🔤 Font Manager inizializzato con controlli individuali");

// ===================================================================
// 🔤 FONT MANAGER - GESTIONE CENTRALIZZATA FONT
// ===================================================================

// CREATE EVENT - Inizializza i font sprite
global.font_main = font_add_sprite_ext(
    spr_fontBasic,  // Font principale
    " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~Ññ¿¡ÁÉÍÓÚáéíóúÜüÖö",
    true,
    1
);

global.font_small = font_add_sprite_ext(
    spr_fontSmall,
    " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~",
    true,
    1
);

// ===== SCALE INDIVIDUALI PER OGNI TIPO DI TESTO =====

// FONT BASIC (spr_fontBasic)
global.scale_dialogue = 1.0;        // Dialoghi NPC
global.scale_time_hud = 1;         // HUD tempo (in alto a destra)
global.scale_quest_text = 1;       // Testo quest manager
global.scale_exit_menu = 1.0;        // Menu di uscita
global.scale_plant_hints = 0.7;      // Indicatori piante ("RMB")
global.scale_fps_counter = 1;      // Contatore FPS

// FONT SMALL (spr_fontSmall) - UI Elements
global.scale_inventory_qty = 0.25;    // Quantità negli slot inventario
global.scale_inventory_tooltip = 0.5; // Tooltip hover inventario
global.scale_toolbar_qty = 0.25;      // Quantità nella toolbar
global.scale_popup_title = 1;      // Titoli popup errore
global.scale_pickup_notifications = 1; // Notifiche pickup sulla testa del player

// ===== FINE INIZIALIZZAZIONE =====
// Le funzioni di rendering sono definite in scr_font_helpers.gml
// per essere accessibili globalmente