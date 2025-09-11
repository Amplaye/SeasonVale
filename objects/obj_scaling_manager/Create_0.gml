// ===================================================================
// 📏 SCALING MANAGER - SISTEMA CENTRALIZZATO SCALING OGGETTI
// ===================================================================
// Gestisce le scale individuali di ogni sprite nel layer "pickupable"
// Permette di modificare facilmente le dimensioni di ogni tipo di oggetto

depth = -10000; // Molto alto per essere eseguito prima di tutto

// Variabile per applicare scale solo una volta
scales_applied = false;

// ===== CONFIGURAZIONE SCALING PER OGNI SPRITE =====
// Formato: sprite_name = {scale_x, scale_y}
// Valori attuali presi dal room - modificabili individualmente

global.sprite_scales = {};

// MATERIALI BASE
global.sprite_scales[$ "spr_wood"] = {scale_x: 0.2, scale_y: 0.2};
global.sprite_scales[$ "spr_rock"] = {scale_x: 0.3, scale_y: 0.3};  
global.sprite_scales[$ "spr_bronze"] = {scale_x: 0.4, scale_y: 0.4};

// VERDURE
global.sprite_scales[$ "spr_aubergine"] = {scale_x: 0.25, scale_y: 0.25};
global.sprite_scales[$ "spr_carrot"] = {scale_x: 0.25, scale_y: 0.25};
global.sprite_scales[$ "spr_corn"] = {scale_x: 0.25, scale_y: 0.25};
global.sprite_scales[$ "spr_cucumber"] = {scale_x: 0.25, scale_y: 0.25};
global.sprite_scales[$ "spr_garlic"] = {scale_x: 0.25, scale_y: 0.25};
global.sprite_scales[$ "spr_lettuce"] = {scale_x: 0.25, scale_y: 0.25};
global.sprite_scales[$ "spr_onion"] = {scale_x: 0.25, scale_y: 0.25};
global.sprite_scales[$ "spr_pepper"] = {scale_x: 0.25, scale_y: 0.25};
global.sprite_scales[$ "spr_potato"] = {scale_x: 0.25, scale_y: 0.25};
global.sprite_scales[$ "spr_pumpkin"] = {scale_x: 0.25, scale_y: 0.25};
global.sprite_scales[$ "spr_tomato"] = {scale_x: 0.25, scale_y: 0.25};

// TOOL
global.sprite_scales[$ "spr_axe"] = {scale_x: 0.45, scale_y: 0.45};
global.sprite_scales[$ "spr_hoe"] = {scale_x: 0.45, scale_y: 0.45};
global.sprite_scales[$ "spr_pickaxe"] = {scale_x: 0.40, scale_y: 0.40};
global.sprite_scales[$ "spr_fishing_rod"] = {scale_x: 0.45, scale_y: 0.45};

// ===== FUNZIONI UTILITY =====

// Ottieni la scala di uno sprite per nome
function get_sprite_scale(sprite_name) {
    if (variable_struct_exists(global.sprite_scales, sprite_name)) {
        return global.sprite_scales[$ sprite_name];
    }
    // Default se non trovato
    return {scale_x: 1.0, scale_y: 1.0};
}

// Imposta la scala di uno sprite
function set_sprite_scale(sprite_name, scale_x, scale_y) {
    global.sprite_scales[$ sprite_name] = {scale_x: scale_x, scale_y: scale_y};
    show_debug_message("📏 Scala aggiornata per " + sprite_name + ": " + string(scale_x) + "x" + string(scale_y));
}

// Ottieni la scala di uno sprite ID
function get_sprite_scale_by_id(sprite_id) {
    var sprite_name = sprite_get_name(sprite_id);
    return get_sprite_scale(sprite_name);
}

// ===== DEBUG INFO =====
show_debug_message("📏 Scaling Manager inizializzato");
show_debug_message("📏 Sprite configurati: " + string(variable_struct_names_count(global.sprite_scales)));

// Lista tutti gli sprite configurati
var sprite_names = variable_struct_get_names(global.sprite_scales);
for (var i = 0; i < array_length(sprite_names); i++) {
    var name = sprite_names[i];
    var scale = global.sprite_scales[$ name];
    show_debug_message("  - " + name + ": " + string(scale.scale_x) + "x" + string(scale.scale_y));
}