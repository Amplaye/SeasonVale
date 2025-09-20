if (visible) {
    // Calcola posizione relativa al centro della view (come il main menu)
    var cam = view_camera[0];
    var view_x = camera_get_view_x(cam);
    var view_y = camera_get_view_y(cam);
    var view_w = camera_get_view_width(cam);
    var view_h = camera_get_view_height(cam);

    var center_x = view_x + view_w / 2;
    var center_y = view_y + view_h / 2;

    // Offset relativo al menu centrato
    var offset_x = -40;
    var offset_y = -78;

    // Calcola posizione finale del mark
    var mark_x = center_x + offset_x;
    var mark_y = center_y + offset_y;

    // Aggiorna posizione per i click
    x = mark_x;
    y = mark_y;

    // Disegna il mark nella posizione relativa al menu
    draw_sprite_ext(spr_mark, image_index, mark_x, mark_y, image_xscale, image_yscale, image_angle, image_blend, 1);

    // Se è attivo, mostra l'interfaccia quest
    if (is_active) {
        draw_set_font(main_font);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        var quest_x = center_x - 150;
        var quest_y = center_y - 50;

        // Titolo
        draw_set_color(c_yellow);
        draw_text(quest_x, quest_y, "=== QUEST MANAGER ===");
        quest_y += 20;

        // Quest attive
        draw_set_color(c_white);
        var active_quests = quest_get_active();
        if (array_length(active_quests) > 0) {
            draw_text(quest_x, quest_y, "Active Quests:");
            quest_y += 15;

            for (var i = 0; i < array_length(active_quests); i++) {
                var quest = active_quests[i];
                draw_set_color(c_lime);
                draw_text(quest_x + 10, quest_y, "• " + quest.name);
                quest_y += 12;

                // Mostra obiettivi
                for (var j = 0; j < array_length(quest.objectives); j++) {
                    var obj = quest.objectives[j];
                    var obj_color = obj.completed ? c_lime : c_yellow;
                    draw_set_color(obj_color);
                    var progress_text = "  - " + obj.description + " (" + string(obj.current) + "/" + string(obj.count) + ")";
                    draw_text(quest_x + 20, quest_y, progress_text);
                    quest_y += 10;
                }
                quest_y += 5;
            }
        } else {
            draw_text(quest_x, quest_y, "No active quests");
            quest_y += 20;
        }

        // Controlli
        draw_set_color(c_aqua);
        draw_text(quest_x, quest_y, "Controls:");
        quest_y += 15;
        draw_set_color(c_white);
        draw_text(quest_x, quest_y, "Q = First Harvest");
        quest_y += 12;
        draw_text(quest_x, quest_y, "W = Welcome to Valley");
        quest_y += 12;
        draw_text(quest_x, quest_y, "E = Resource Gathering");

        // Reset
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
    }
}