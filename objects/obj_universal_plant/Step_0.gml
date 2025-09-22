// ===================================================================
// 🌱 UNIVERSAL PLANT - STEP EVENT
// ===================================================================

// Esci se non inizializzato
if (plant_type == "") exit;


// Se caricata da save, NON fare mai controlli automatici di crescita
if (is_loaded_from_save) {
    // Le piante caricate mantengono il loro stato esatto
    // La crescita avverrà solo con advance_day() espliciti
    if (harvest_cooldown > 0) harvest_cooldown--;

    // HARVESTING RIMOSSO - gestito centralmente dal player
    // Il player gestisce tutto l'harvesting con precisione
    exit;  // Salta advance_plant_growth
}

// Riduci cooldown harvest
if (harvest_cooldown > 0) {
    harvest_cooldown--;
}

// Controlla crescita giornaliera usando il sistema centralizzato
advance_plant_growth(id);

