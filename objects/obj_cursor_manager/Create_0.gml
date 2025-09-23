// ===================================================================
// 🖱️ CURSOR MANAGER - GESTIONE CURSOR DI GIOCO
// ===================================================================
// Oggetto dedicato per disegnare il cursor sopra tutto nel Draw_64
// Il Draw_64 si disegna automaticamente sopra tutto, non serve depth estremi

// Singleton pattern - solo un cursor manager
if (instance_number(obj_cursor_manager) > 1) {
    instance_destroy();
    exit;
}

depth = -100; // Depth normale, Draw_64 gestisce la priorità
persistent = true; // Mantieni tra le room