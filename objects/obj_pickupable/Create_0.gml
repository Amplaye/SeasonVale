// ===================================================================
// 🧲 SISTEMA RACCOLTA MAGNETICA - CONFIGURAZIONE
// ===================================================================
// Sistema centralizzato per raccolta automatica di sprite dal layer "pickupable"
// Rileva vicinanza del player e raccoglie automaticamente gli oggetti

// ===== CONFIGURAZIONE OGGETTI RACCOGLIBILI =====
// Lista degli sprite che possono essere raccolti
global.pickupable_sprites = [
    spr_rock,
    spr_wood,
	spr_bronze,
	spr_tomato,
	spr_corn,
	spr_garlic,
	spr_lettuce,
	spr_carrot,
    // Aggiungi qui altri sprite in futuro
];

// ===== IMPOSTAZIONI RACCOLTA =====
global.pickup_range = 20;           // Distanza massima per la raccolta (pixel)
global.pickup_cooldown = 0;         // Cooldown per evitare spam
global.pickup_cooldown_max = 10;    // Frame di cooldown tra una raccolta e l'altra

// ===== SISTEMA MAGNETE =====
global.magnet_enabled = true;       // Abilita effetto magnete
global.magnet_range = 48;           // Raggio di attrazione magnete (più grande del pickup)
global.magnet_speed = 2;            // Velocità di attrazione degli oggetti

// ===== DEBUG E FEEDBACK =====
global.pickup_debug = true;         // Mostra info debug
global.pickup_effects = true;       // Effetti visivi/sonori

// ===== RIFERIMENTI SISTEMA =====
global.player_obj = obj_player;     // Riferimento al player
global.pickup_layer_name = "pickupable";  // Nome del layer da controllare

show_debug_message("🧲 Sistema Raccolta inizializzato:");
show_debug_message("  - Sprite raccoglibili: " + string(array_length(global.pickupable_sprites)));
show_debug_message("  - Range raccolta: " + string(global.pickup_range) + "px");
show_debug_message("  - Range magnete: " + string(global.magnet_range) + "px");