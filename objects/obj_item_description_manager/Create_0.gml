// ===================================================================
// 📖 ITEM DESCRIPTION MANAGER - SISTEMA DESCRIZIONI ITEMS
// ===================================================================
// Gestisce tutte le descrizioni degli oggetti del gioco
// Struttura organizzata per categorie facilmente espandibile

depth = -9000; // Manager layer

// ===== INIZIALIZZA SISTEMA DESCRIZIONI =====
if (!variable_global_exists("item_descriptions")) {
    global.item_descriptions = {};

    // ===== CATEGORIA: ATTREZZI (solo sprite che esistono sicuramente) =====
    if (sprite_exists(spr_axe)) {
        global.item_descriptions[$ sprite_get_name(spr_axe)] = {
            name: "Ascia",
            description: "Un'ascia affilata per tagliare alberi e raccogliere legno. Indispensabile per costruire e craftare.",
            category: "tool",
            rarity: "common"
        };
    }

    if (sprite_exists(spr_pickaxe)) {
        global.item_descriptions[$ sprite_get_name(spr_pickaxe)] = {
            name: "Piccone",
            description: "Un piccone robusto per estrarre minerali dalle rocce. Perfetto per ottenere bronzo e altre risorse.",
            category: "tool",
            rarity: "common"
        };
    }

    if (sprite_exists(spr_hoe)) {
        global.item_descriptions[$ sprite_get_name(spr_hoe)] = {
            name: "Zappa",
            description: "Una zappa per lavorare la terra e preparare i campi per la semina. Essenziale per l'agricoltura.",
            category: "tool",
            rarity: "common"
        };
    }

    if (sprite_exists(spr_fishing_rod)) {
        global.item_descriptions[$ sprite_get_name(spr_fishing_rod)] = {
            name: "Canna da Pesca",
            description: "Una canna da pesca per catturare pesci dai fiumi e laghi. Fonte importante di cibo.",
            category: "tool",
            rarity: "common"
        };
    }

    // ===== CATEGORIA: SEMI =====
    if (sprite_exists(spr_tomato)) {
        global.item_descriptions[$ sprite_get_name(spr_tomato)] = {
            name: "Semi di Pomodoro",
            description: "Semi freschi di pomodoro. Crescono rapidamente e producono frutti rossi e succosi.",
            category: "seed",
            rarity: "common",
            grow_time: "3 giorni",
            season: "Estate"
        };
    }

    if (sprite_exists(spr_carrot)) {
        global.item_descriptions[$ sprite_get_name(spr_carrot)] = {
            name: "Semi di Carota",
            description: "Semi di carota croccante. Crescono sottoterra e sono ricchi di vitamine.",
            category: "seed",
            rarity: "common",
            grow_time: "4 giorni",
            season: "Primavera/Autunno"
        };
    }

    // ===== CATEGORIA: RISORSE =====
    if (sprite_exists(spr_wood)) {
        global.item_descriptions[$ sprite_get_name(spr_wood)] = {
            name: "Legno",
            description: "Tronchi di legno resistente ottenuti tagliando alberi. Materiale base per costruzioni.",
            category: "resource",
            rarity: "common"
        };
    }

    if (sprite_exists(spr_bronze)) {
        global.item_descriptions[$ sprite_get_name(spr_bronze)] = {
            name: "Bronzo",
            description: "Minerale di bronzo lucente estratto dalle rocce. Utilizzato per creare attrezzi migliori.",
            category: "resource",
            rarity: "uncommon"
        };
    }

    show_debug_message("📖 Item Description Manager inizializzato con " + string(struct_names_count(global.item_descriptions)) + " descrizioni");
}

// ===== FUNZIONI UTILITÀ =====

// Ottiene la descrizione completa di un item
function get_item_description(sprite_or_name) {
    var sprite_name = "";

    if (is_string(sprite_or_name)) {
        sprite_name = sprite_or_name;
    } else if (sprite_exists(sprite_or_name)) {
        sprite_name = sprite_get_name(sprite_or_name);
    } else {
        return undefined;
    }

    if (variable_struct_exists(global.item_descriptions, sprite_name)) {
        return global.item_descriptions[$ sprite_name];
    }

    return undefined;
}

// Ottiene solo il nome di un item
function get_item_name(sprite_or_name) {
    var desc = get_item_description(sprite_or_name);
    if (desc != undefined) {
        return desc.name;
    }
    return "Oggetto Sconosciuto";
}

// Ottiene solo la descrizione testuale di un item
function get_item_description_text(sprite_or_name) {
    var desc = get_item_description(sprite_or_name);
    if (desc != undefined) {
        return desc.description;
    }
    return "Nessuna descrizione disponibile.";
}

// Ottiene la categoria di un item
function get_item_category(sprite_or_name) {
    var desc = get_item_description(sprite_or_name);
    if (desc != undefined) {
        return desc.category;
    }
    return "unknown";
}

// Ottiene la rarità di un item
function get_item_rarity(sprite_or_name) {
    var desc = get_item_description(sprite_or_name);
    if (desc != undefined) {
        return desc.rarity;
    }
    return "common";
}

// Ottiene il colore basato sulla rarità
function get_rarity_color(rarity) {
    switch(rarity) {
        case "common": return c_white;
        case "uncommon": return c_lime;
        case "rare": return c_aqua;
        case "epic": return c_purple;
        case "legendary": return c_orange;
        default: return c_white;
    }
}

// Funzione per aggiungere nuovi item (per futuro utilizzo)
function add_item_description(sprite_name, name, description, category, rarity = "common", extra_data = {}) {
    var item_data = {
        name: name,
        description: description,
        category: category,
        rarity: rarity
    };

    // Aggiungi dati extra se forniti
    var extra_keys = struct_get_names(extra_data);
    for (var i = 0; i < array_length(extra_keys); i++) {
        var key = extra_keys[i];
        item_data[$ key] = extra_data[$ key];
    }

    global.item_descriptions[$ sprite_name] = item_data;
    show_debug_message("📖 Aggiunta descrizione per: " + name);
}