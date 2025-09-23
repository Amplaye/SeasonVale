// Controlla input per toggle fullscreen
if (keyboard_check_pressed(vk_f11)) {
    toggle_fullscreen();
}

// Controlli per cambio qualità rimossi

// Reset perfetto con R
if (keyboard_check_pressed(ord("R"))) {
    fix_pixel_perfect();
}

// Controlli scala font (con tasti + e -)
if (keyboard_check_pressed(vk_add) || keyboard_check_pressed(ord("="))) {
    set_font_scale(global.font_scale + 0.1);
}
if (keyboard_check_pressed(vk_subtract) || keyboard_check_pressed(ord("-"))) {
    set_font_scale(max(0.3, global.font_scale - 0.1));
}

// Mantieni sempre le impostazioni pixel perfect
if (gpu_get_tex_filter()) {
    gpu_set_tex_filter(false);
}