// ===================================================================
// 📢 PICKUP NOTIFICATIONS MANAGER - SISTEMA NOTIFICHE RACCOLTA
// ===================================================================

// Array delle notifiche attive (massimo 4)
notifications = [];

// Configurazione notifiche
max_notifications = 4;
notification_duration = 120; // frames (2 secondi a 60fps)
notification_height = 15; // altezza di ogni riga (in GUI space)
notification_offset_x = 30; // offset a destra della testa del player (in GUI space)
notification_offset_y = -50; // offset sopra la testa del player (in GUI space)

// Configurazione sprite
sprite_scale = 1; // scala dello sprite nelle notifiche

// Animazione scroll
scroll_speed = 2; // velocità scroll in pixel per frame
fade_out_frames = 30; // frames per il fade out

// ===== MAPPING SPRITE -> NOME ITEM =====
// Mappa i sprite ID ai nomi veri degli items
function get_item_name(sprite_id) {
    switch (sprite_id) {
        // Verdure
        case spr_tomato: return "Pomodoro";
        case spr_tomatoes: return "Pomodori";
        case spr_carrot: return "Carota";
        case spr_lettuce: return "Lattuga";
        case spr_corn: return "Mais";
        case spr_aubergine: return "Melanzana";
        case spr_pepper: return "Peperone";
        case spr_onion: return "Cipolla";
        case spr_garlic: return "Aglio";
        case spr_pumpkin: return "Zucca";
        case spr_potato: return "Patata";
        case spr_cucumber: return "Cetriolo";

        // Materiali
        case spr_wood: return "Legno";
        case spr_rock: return "Pietra";
        case spr_bronze: return "Bronzo";

        // Attrezzi
        case spr_axe: return "Ascia";
        case spr_hoe: return "Zappa";
        case spr_pickaxe: return "Piccone";
        case spr_fishing_rod: return "Canna da Pesca";

        default:
            // Fallback al nome dello sprite se non mappato
            var sprite_name = sprite_get_name(sprite_id);
            // Rimuovi prefisso "spr_" se presente
            if (string_pos("spr_", sprite_name) == 1) {
                sprite_name = string_delete(sprite_name, 1, 4);
            }
            return string_upper(string_char_at(sprite_name, 1)) + string_copy(sprite_name, 2, string_length(sprite_name));
    }
}

// Inizializza il sistema di gestione sprite per notifiche
init_notification_sprite_settings();

show_debug_message("📢 Pickup Notifications Manager initialized");