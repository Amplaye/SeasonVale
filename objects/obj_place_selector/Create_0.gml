// ===================================================================
// 🎯 PLACE SELECTOR - SELETTORE VISIVO MOUSE
// ===================================================================
// Oggetto che segue il mouse per indicare dove si può fare chopping/azioni

// Configurazione
depth = -5000; // Disegnato sopra tutto (ma sotto UI)
visible = true;
// Scala normale per pointer, ridotta per selector
image_xscale = 1.0;
image_yscale = 1.0;

// Stato iniziale
image_alpha = 1.0;
image_speed = 0;
sprite_index = spr_pointer;

show_debug_message("🎯 Place selector inizializzato");