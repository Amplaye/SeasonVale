// ===================================================================
// 🎒 INVENTORY SYSTEM - CONFIGURAZIONE CENTRALE  
// ===================================================================
// Gestisce inventario 3x10 (30 slot totali)
// Riga 1: 10 slot condivisi con toolbar (disponibili subito)
// Riga 2-3: 20 slot bloccati (acquistabili in futuro)
// Gap verticale: 2 pixel tra righe

depth = -7000; // Inventory manager - layer Meta

// ===== IMPOSTAZIONI INVENTARIO =====
global.inventory_rows = 3;
global.inventory_cols = 10;
global.inventory_total_slots = global.inventory_rows * global.inventory_cols;
global.inventory_gap_x = 1; // Gap orizzontale tra slot
global.inventory_gap_y = 2; // Gap verticale tra righe
global.inventory_visible = false; // Inizialmente nascosto

// ===== SCALING MANUALE INVENTARIO =====
global.inventory_scale = 0.85; // Scala globale inventario
global.slot_scale = 0.7; // Scala specifica slot
global.inventory_background_scale = 1.0; // Scala background inventario

// Variabile per trash chest dedicata all'inventario
inventory_trash_chest = noone;

// ===== SISTEMA HOVER TOOLTIP =====
hovered_slot = -1;        // Slot attualmente in hover (-1 = nessuno)
hovered_item_sprite = noone;  // Sprite dell'item in hover
hover_tooltip_alpha = 0;  // Alpha per fade in/out del tooltip

// ===== SISTEMA DI ESPANSIONE =====
// Riga 0: slot 0-9 (condivisi con toolbar - sempre disponibili)
// Riga 1: slot 10-19 (acquistabili)  
// Riga 2: slot 20-29 (acquistabili)
global.inventory_unlocked_rows = 1; // Solo prima riga disponibile inizialmente

// ===== POSIZIONAMENTO INIZIALE =====
// Il posizionamento effettivo viene calcolato nel Step per seguire la camera
x = 0;
y = 0;

// ===== STORAGE ITEMS (CONDIVISIONE REALE CON TOOLBAR) =====
// L'inventario NON ha un suo array separato per i primi 10 slot
// Usa direttamente gli array della toolbar per i primi 10, array separato per gli altri 20
if (!variable_global_exists("inventory_extended_sprites")) {
    // Array solo per gli slot 10-29 (le righe 2 e 3)
    global.inventory_extended_sprites = array_create(20, noone);
    global.inventory_extended_quantities = array_create(20, 0);
    
    show_debug_message("🎒 Inventario inizializzato: " + string(global.inventory_total_slots) + " slot totali");
    show_debug_message("  Primi 10 slot: condivisi con toolbar");
    show_debug_message("  Slot 10-29: array separato inventory_extended");
    show_debug_message("  Righe sbloccate: " + string(global.inventory_unlocked_rows) + "/" + string(global.inventory_rows));
}

// ===== FUNZIONI UTILITÀ =====
// Funzione per convertire indice slot in coordinate riga/colonna
function slot_to_row_col(slot_index) {
    var row = floor(slot_index / global.inventory_cols);
    var col = slot_index % global.inventory_cols;
    return [row, col];
}

// Funzione per verificare se uno slot è sbloccato
function is_slot_unlocked(slot_index) {
    var row_col = slot_to_row_col(slot_index);
    var row = row_col[0];
    return row < global.inventory_unlocked_rows;
}

// Funzione per ottenere sprite e quantità di uno slot
function get_slot_data(slot_index) {
    var sprite_val = noone;
    var quantity_val = 0;
    
    if (slot_index < 10) {
        // Primi 10 slot: usa toolbar
        if (variable_global_exists("tool_sprites") && slot_index < array_length(global.tool_sprites)) {
            sprite_val = global.tool_sprites[slot_index];
        }
        if (variable_global_exists("tool_quantities") && slot_index < array_length(global.tool_quantities)) {
            quantity_val = global.tool_quantities[slot_index];
        }
    } else {
        // Slot 10-29: usa array esteso
        var extended_index = slot_index - 10;
        if (extended_index < array_length(global.inventory_extended_sprites)) {
            sprite_val = global.inventory_extended_sprites[extended_index];
            quantity_val = global.inventory_extended_quantities[extended_index];
        }
    }
    
    return [sprite_val, quantity_val];
}

// Funzione per impostare sprite e quantità di uno slot
function set_slot_data(slot_index, sprite_val, quantity_val) {
    if (slot_index < 10) {
        // Primi 10 slot: modifica toolbar
        if (variable_global_exists("tool_sprites") && slot_index < array_length(global.tool_sprites)) {
            global.tool_sprites[slot_index] = sprite_val;
        }
        if (variable_global_exists("tool_quantities") && slot_index < array_length(global.tool_quantities)) {
            global.tool_quantities[slot_index] = quantity_val;
        }
    } else {
        // Slot 10-29: modifica array esteso
        var extended_index = slot_index - 10;
        if (extended_index < array_length(global.inventory_extended_sprites)) {
            global.inventory_extended_sprites[extended_index] = sprite_val;
            global.inventory_extended_quantities[extended_index] = quantity_val;
        }
    }
}

// Funzione per calcolare posizione pixel di uno slot
function get_slot_position(slot_index) {
    var row_col = slot_to_row_col(slot_index);
    var row = row_col[0];
    var col = row_col[1];
    
    var scaled_slot_width = sprite_get_width(spr_slot) * global.slot_scale * global.inventory_scale;
    var scaled_slot_height = sprite_get_height(spr_slot) * global.slot_scale * global.inventory_scale;
    
    var slot_x = x + (col * (scaled_slot_width + global.inventory_gap_x));
    var slot_y = y + (row * (scaled_slot_height + global.inventory_gap_y));
    
    return [slot_x, slot_y];
}