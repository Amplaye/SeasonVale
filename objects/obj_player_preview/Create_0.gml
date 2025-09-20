visible = false;
depth = -15001; // Deve essere sopra il menu (-15000) - layer Meta

// Forza GameMaker a includere lo sprite nella compilazione
sprite_ref = spr_idle_front;
base_sprite = spr_idle_front;
current_frame = 0;
frame_speed = 8;

// Offset fisso relativo al centro del menu (calcolato dalla posizione editor)
// Player preview è a x=189, y=160 nell'editor, centro menu è circa 240,137
offset_from_menu_x = -51; 
offset_from_menu_y = -20;   