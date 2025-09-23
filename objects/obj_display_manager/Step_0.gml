// Toggle fullscreen con F11
if (keyboard_check_pressed(vk_f11)) {
    toggle_fullscreen();
}

// Mantieni sempre pixel perfect su Mac
if (os_type == os_macosx) {
    // Force texture filtering off costantemente su Mac
    if (gpu_get_tex_filter()) {
        gpu_set_tex_filter(false);
        gpu_set_tex_filter_ext(0, false);
        gpu_set_tex_filter_ext(1, false);
    }
} else {
    // Su altri OS, controllo normale
    if (gpu_get_tex_filter()) {
        gpu_set_tex_filter(false);
    }
}