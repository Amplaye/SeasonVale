// Logica specifica per la pagina Exit
if (is_active && visible) {
    // Mostra opzioni di uscita

    // Premi ENTER per confermare uscita
    if (keyboard_check_pressed(vk_enter)) {
        show_debug_message("Exiting game...");
        game_end();
    }

    // Premi ESC per annullare
    if (keyboard_check_pressed(vk_escape)) {
        show_debug_message("Exit cancelled");
        is_active = false;
        image_index = 0; // Frame 0 = chiuso
    }
}