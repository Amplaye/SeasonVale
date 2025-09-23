// ===================================================================
// 🎒 INVENTORY INPUT - GESTIONE CONTROLLI
// ===================================================================

// ===== TOGGLE INVENTARIO =====
// Tasto I per aprire/chiudere inventario (solo se il menu non è aperto)
if (keyboard_check_pressed(ord("I"))) {
    var menu_is_open = (instance_exists(obj_main_menu) && obj_main_menu.visible);

    if (!menu_is_open) {
        global.inventory_visible = !global.inventory_visible;
        show_debug_message("🎒 Inventario " + (global.inventory_visible ? "aperto" : "chiuso"));
    } else {
        show_debug_message("🚫 Impossibile aprire inventario: menu principale aperto");
    }
}

// ===== UI FISSA - POSIZIONAMENTO IDENTICO TOOLBAR =====
// STESSA LOGICA DELLA TOOLBAR per seguire la camera
var cam = view_camera[0];
var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);

var screen_w = 480;
var screen_h = 270;
// Usa cached values per performance
check_cache_validity();
var scaled_slot_width = cached_scaled_slot_width;

// ===== RESET HOVER STATE =====
var old_hovered_slot = hovered_slot;
hovered_slot = -1;
hovered_item_sprite = noone;
var scaled_slot_height = cached_scaled_slot_height;

// Calcola dimensioni totali inventario
var total_width = (global.inventory_cols * scaled_slot_width) + ((global.inventory_cols - 1) * global.inventory_gap_x);
var total_height = (global.inventory_rows * scaled_slot_height) + ((global.inventory_rows - 1) * global.inventory_gap_y);

// Posiziona centrato nella camera (ESATTAMENTE come toolbar)
var inventory_start_x = cam_x + (screen_w - total_width) / 2;
var inventory_start_y = cam_y + (screen_h - total_height) / 2;

x = inventory_start_x;
y = inventory_start_y;

// ===== GESTIONE DRAG & DROP INVENTORY OTTIMIZZATO =====
if (global.inventory_visible) {
    // Check cache validity
    check_cache_validity();

    // Calcola slot mouse solo se mouse si è mosso o ci sono click
    var mouse_moved = (mouse_x != previous_mouse_x || mouse_y != previous_mouse_y);
    var mouse_clicked = mouse_check_button_pressed(mb_left);

    // Reset hover se mouse si muove
    if (mouse_moved) {
        hovered_slot = -1;
        hovered_item_sprite = noone;
        hover_start_time = 0;
        mouse_stopped = false;
    }

    // Calcolo slot attuale ottimizzato (direct calculation)
    var current_slot = -1;
    var current_item = noone;

    var rel_x = mouse_x - x;
    var rel_y = mouse_y - y;

    if (rel_x >= 0 && rel_y >= 0) {
        var col = floor(rel_x / (cached_scaled_slot_width + global.inventory_gap_x));
        var row = floor(rel_y / (cached_scaled_slot_height + global.inventory_gap_y));

        if (col >= 0 && col < global.inventory_cols && row >= 0 && row < global.inventory_rows) {
            var slot_index = row * global.inventory_cols + col;

            if (slot_index < global.inventory_total_slots) {
                // Usa cache per tutti gli slot
                var cached_pos = slot_positions_cache[slot_index];
                var slot_x = x + cached_pos[0];
                var slot_y = y + cached_pos[1];

                var mouse_over = point_in_rectangle(mouse_x, mouse_y, slot_x, slot_y, slot_x + cached_scaled_slot_width, slot_y + cached_scaled_slot_height);

                if (mouse_over && is_slot_unlocked(slot_index)) {
                    var slot_data = get_slot_data(slot_index);
                    var item_sprite = slot_data[0];
                    var quantity = slot_data[1];

                    if (item_sprite != noone && quantity > 0) {
                        current_slot = slot_index;
                        current_item = item_sprite;
                    }

                    // CLICK HANDLING
                    if (mouse_clicked) {
                        if (item_sprite != noone) {
                            global.toolbar_dragging = true;
                            global.toolbar_drag_from_slot = slot_index;
                            global.toolbar_drag_item = item_sprite;
                            global.toolbar_drag_start_x = mouse_x;
                            global.toolbar_drag_start_y = mouse_y;
                            if (slot_index < 10) {
                                global.selected_tool = slot_index;
                            }
                        } else if (slot_index < 10) {
                            global.selected_tool = slot_index;
                        }
                    }
                } else if (mouse_over && !is_slot_unlocked(slot_index) && mouse_clicked) {
                    show_debug_message("🔒 Slot bloccato! Espandi l'inventario per usarlo.");
                }
            }
        }
    }

    // HOVER LOGIC semplificata
    if (current_slot != -1 && current_item != noone) {
        // Mouse sopra item valido
        if (hovered_slot != current_slot) {
            // Cambio di item - reset timer
            hover_start_time = 0;
            mouse_stopped = false;
            hovered_slot = -1;
            hovered_item_sprite = noone;
        }

        if (!mouse_moved && !mouse_stopped) {
            // Mouse fermo su item, inizia/continua timer
            if (hover_start_time == 0) {
                hover_start_time = current_time;
            }
            if (current_time - hover_start_time >= (hover_delay * 1000 / 60)) {
                // Timer scaduto - mostra tooltip e mantienilo
                hovered_slot = current_slot;
                hovered_item_sprite = current_item;
                mouse_stopped = true;
            }
        } else if (mouse_stopped && hovered_slot == current_slot) {
            // Tooltip già attivo su stesso item - mantieni
            hovered_slot = current_slot;
            hovered_item_sprite = current_item;
        }
    } else {
        // Mouse non su nessun item - reset tutto
        if (hovered_slot != -1) {
            hovered_slot = -1;
            hovered_item_sprite = noone;
            hover_start_time = 0;
            mouse_stopped = false;
        }
    }

    // Aggiorna posizione mouse
    previous_mouse_x = mouse_x;
    previous_mouse_y = mouse_y;
    
    // DRAG DROP - gestione rilascio
    if (global.toolbar_dragging && mouse_check_button_released(mb_left)) {
        // Prima controlla se si sta droppando sulla trash chest
        var dropped_on_trash = false;
        if (inventory_trash_chest != noone && instance_exists(inventory_trash_chest)) {
            var trash_obj = inventory_trash_chest;
            if (point_in_rectangle(mouse_x, mouse_y, trash_obj.x, trash_obj.y, trash_obj.x + trash_obj.sprite_width, trash_obj.y + trash_obj.sprite_height)) {
                dropped_on_trash = true;
                show_debug_message("🗑️ DROP SU TRASH CHEST - Lasciamo che obj_trash_chest gestisca");
            }
        }
        
        // Solo se NON è stato droppato sulla trash, gestisci il drop nell'inventory
        if (!dropped_on_trash) {
            show_debug_message("🖱️ Drop nell'inventory - controllo slot target");
            
            var drop_slot = -1;
        
        // Drop detection ottimizzato con calcolo diretto
        var drop_rel_x = mouse_x - x;
        var drop_rel_y = mouse_y - y;

        if (drop_rel_x >= 0 && drop_rel_y >= 0) {
            var col = floor(drop_rel_x / (cached_scaled_slot_width + global.inventory_gap_x));
            var row = floor(drop_rel_y / (cached_scaled_slot_height + global.inventory_gap_y));

            if (col >= 0 && col < global.inventory_cols && row >= 0 && row < global.inventory_rows) {
                var potential_slot = row * global.inventory_cols + col;

                if (potential_slot < global.inventory_total_slots && is_slot_unlocked(potential_slot)) {
                    var cached_pos = slot_positions_cache[potential_slot];
                    var slot_x = x + cached_pos[0];
                    var slot_y = y + cached_pos[1];

                    if (point_in_rectangle(mouse_x, mouse_y, slot_x, slot_y, slot_x + cached_scaled_slot_width, slot_y + cached_scaled_slot_height)) {
                        drop_slot = potential_slot;
                    }
                }
            }
        }
        
        if (drop_slot >= 0 && drop_slot != global.toolbar_drag_from_slot) {
            show_debug_message("🔄 Swap tra slot " + string(global.toolbar_drag_from_slot) + " e " + string(drop_slot));
            
            // Gestisce swap tra qualsiasi combinazione di slot inventory/toolbar
            var source_data = get_slot_data(global.toolbar_drag_from_slot);
            var target_data = get_slot_data(drop_slot);
            
            set_slot_data(drop_slot, source_data[0], source_data[1]);
            set_slot_data(global.toolbar_drag_from_slot, target_data[0], target_data[1]);
        }
        
            // Reset drag state solo se non droppato su trash
            global.toolbar_dragging = false;
            global.toolbar_drag_from_slot = -1;
            global.toolbar_drag_item = noone;
        }
        // Se droppato su trash, obj_trash_chest gestirà il reset
    }
}

// ===== AGGIORNA ALPHA TOOLTIP =====
if (hovered_slot != -1 && hovered_item_sprite != noone) {
    // Tooltip attivo - mantieni alpha a 1.0
    hover_tooltip_alpha = 1.0;
} else {
    // Nessun hover - nasconde tooltip
    hover_tooltip_alpha = 0.0;
}

// ===== GESTIONE TRASH CHEST =====
if (global.inventory_visible) {
    // Calcola posizione per trash chest
    var inventory_end_x = x + (global.inventory_cols * scaled_slot_width) + ((global.inventory_cols - 1) * global.inventory_gap_x);
    var inventory_end_y = y + (global.inventory_rows * scaled_slot_height) + ((global.inventory_rows - 2.2) * global.inventory_gap_y);
    
    var trash_x = inventory_end_x + 10;
    // Allinea la trash chest al bottom dell'inventario (non considerando il padding)
    var trash_y = inventory_end_y - (sprite_get_height(spr_trash_chest) * global.slot_scale * global.inventory_scale);
    
    // Crea istanza se non esiste
    if (inventory_trash_chest == noone || !instance_exists(inventory_trash_chest)) {
        show_debug_message("🗑️ CREANDO trash chest - inventory_visible = " + string(global.inventory_visible));
        inventory_trash_chest = instance_create_layer(trash_x, trash_y, "UI", obj_trash_chest);
    } else {
        // Aggiorna posizione
        inventory_trash_chest.x = trash_x;
        inventory_trash_chest.y = trash_y;
        inventory_trash_chest.visible = true;
    }
} else {
    // Distruggi quando inventario chiuso
    if (inventory_trash_chest != noone && instance_exists(inventory_trash_chest)) {
        show_debug_message("🗑️ DISTRUGGENDO trash chest - inventory chiuso");
        instance_destroy(inventory_trash_chest);
        inventory_trash_chest = noone;
    }
}