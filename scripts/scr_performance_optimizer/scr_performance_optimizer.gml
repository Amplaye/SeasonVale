// ===================================================================
// 🚀 PERFORMANCE OPTIMIZER - OTTIMIZZAZIONI SPECIFICHE CROSS-PLATFORM
// ===================================================================
// Ottimizza automaticamente in base al sistema operativo

// ===== DETECTION OS =====
function detect_platform() {
    static platform_detected = undefined;

    if (platform_detected == undefined) {
        switch(os_type) {
            case os_macosx:
                platform_detected = "mac";
                break;
            case os_windows:
                platform_detected = "windows";
                break;
            default:
                platform_detected = "other";
        }
        show_debug_message("🖥️ Platform detected: " + platform_detected);
    }

    return platform_detected;
}

// ===== OTTIMIZZAZIONI MAC M2 =====
function apply_mac_optimizations() {
    if (detect_platform() != "mac") return;

    show_debug_message("🍎 Applying Mac M2 optimizations...");

    // 1. Riduci frequency del depth sorting
    if (instance_exists(obj_depth_sorted)) {
        with (obj_depth_sorted) {
            // Su Mac, aggiorna depth ogni 3 frame invece di ogni frame
            if (global.frame_count % 3 == 0) {
                depth = -y;
            }
        }
    }

    // 2. Ottimizza find operations per Mac
    global.mac_instance_cache ??= {};

    // 3. Disabilita debug messages su Mac per performance
    global.debug_enabled = false;

    // 4. Ottimizza collision checking
    global.collision_optimization_mac = true;

    show_debug_message("✅ Mac optimizations applied");
}

// ===== OTTIMIZZAZIONI WINDOWS =====
function apply_windows_optimizations() {
    if (detect_platform() != "windows") return;

    show_debug_message("🪟 Applying Windows optimizations...");

    // Windows può gestire debug messages senza problemi
    global.debug_enabled = true;

    // Depth sorting ogni frame su Windows (più potente)
    global.collision_optimization_mac = false;

    show_debug_message("✅ Windows optimizations applied");
}

// ===== CACHE SYSTEM PER MAC =====
function get_cached_instance(object_type, cache_key) {
    if (detect_platform() != "mac") {
        // Su Windows usa find normale
        return instance_find(object_type, 0);
    }

    // Su Mac usa cache per ridurre find operations
    global.mac_instance_cache ??= {};

    if (!variable_struct_exists(global.mac_instance_cache, cache_key)) {
        global.mac_instance_cache[$ cache_key] = instance_find(object_type, 0);
    }

    var cached_instance = global.mac_instance_cache[$ cache_key];

    // Verifica se l'istanza è ancora valida
    if (cached_instance == noone || !instance_exists(cached_instance)) {
        global.mac_instance_cache[$ cache_key] = instance_find(object_type, 0);
        cached_instance = global.mac_instance_cache[$ cache_key];
    }

    return cached_instance;
}

// ===== DEBUG SMART (solo quando necessario) =====
function smart_debug_message(message) {
    // Su Mac, mostra debug solo se esplicitamente richiesto
    if (detect_platform() == "mac" && !global.force_debug_mac) {
        return;
    }

    show_debug_message(message);
}

// ===== DEPTH SORTING OTTIMIZZATO =====
function optimized_depth_update(instance_id) {
    with (instance_id) {
        var platform = detect_platform();

        if (platform == "mac") {
            // Su Mac, aggiorna solo se la posizione è cambiata significativamente
            if (!variable_instance_exists(id, "last_depth_y")) {
                self.last_depth_y = y;
                depth = -y;
            } else if (abs(y - self.last_depth_y) > 8) {
                self.last_depth_y = y;
                depth = -y;
            }
        } else {
            // Su Windows, aggiorna sempre
            depth = -y;
        }
    }
}

// ===== AUTO-SETUP OTTIMIZZAZIONI =====
function initialize_performance_optimizations() {
    global.frame_count = 0;
    global.performance_initialized = true;

    var platform = detect_platform();

    switch(platform) {
        case "mac":
            apply_mac_optimizations();
            show_debug_message("🚀 Performance system initialized for Mac M2");
            break;

        case "windows":
            apply_windows_optimizations();
            show_debug_message("🚀 Performance system initialized for Windows");
            break;

        default:
            show_debug_message("🚀 Performance system initialized for generic platform");
    }

    // Crea FPS counter automaticamente se non esiste
    if (!instance_exists(obj_fps_counter)) {
        // Usa layer "World" che esiste in tutte le room
        instance_create_layer(0, 0, "World", obj_fps_counter);
        smart_debug_message("📊 FPS Counter created automatically");
    }
}

// ===== FRAME COUNTER =====
function increment_frame_counter() {
    global.frame_count++;

    // Auto profiling per Mac
    auto_profile_mac();
}

show_debug_message("🚀 Performance Optimizer loaded successfully!");