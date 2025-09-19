// ===================================================================
// 📊 PROFILER - SISTEMA DI MONITORAGGIO PERFORMANCE
// ===================================================================
// Identifica bottleneck specificamente su Mac M2

// ===== PROFILER VARIABLES =====
global.profiler_enabled = false;
global.profiler_data = {};
global.profiler_frame_start = 0;

// ===== INIT PROFILER =====
function init_profiler() {
    if (!variable_global_exists("profiler_data") || global.profiler_data == undefined) {
        global.profiler_data = {};
    }
    if (!variable_global_exists("profiler_enabled")) {
        global.profiler_enabled = false;
    }
    if (!variable_global_exists("profiler_frame_start")) {
        global.profiler_frame_start = 0;
    }
}

// ===== PROFILER FUNCTIONS =====

function profiler_start(section_name) {
    if (!global.profiler_enabled) return;

    // Assicurati che profiler_data sia inizializzato
    if (global.profiler_data == undefined) {
        global.profiler_data = {};
    }

    global.profiler_data[$ section_name] = {
        start_time: get_timer(),
        calls: 0,
        total_time: 0
    };
}

function profiler_end(section_name) {
    if (!global.profiler_enabled) return;

    // Assicurati che profiler_data sia inizializzato
    if (global.profiler_data == undefined) {
        global.profiler_data = {};
        return;
    }

    if (!variable_struct_exists(global.profiler_data, section_name)) return;

    var section = global.profiler_data[$ section_name];
    var elapsed = get_timer() - section.start_time;

    section.total_time += elapsed;
    section.calls++;
}

function profiler_enable() {
    global.profiler_enabled = true;
    global.profiler_frame_start = get_timer();
    // show_debug_message("📊 Profiler enabled - monitoring performance");
}

function profiler_disable() {
    global.profiler_enabled = false;
    // show_debug_message("📊 Profiler disabled");
}

function profiler_report() {
    if (!global.profiler_enabled) return;

    // Assicurati che profiler_data sia inizializzato
    if (global.profiler_data == undefined) {
        global.profiler_data = {};
        return;
    }

    var frame_time = get_timer() - global.profiler_frame_start;
    var sections = variable_struct_get_names(global.profiler_data);

    // Commenta i report per evitare spam nella console
    // show_debug_message("📊 === PERFORMANCE REPORT ===");
    // show_debug_message("Frame time: " + string(frame_time / 1000) + "ms");
    // show_debug_message("FPS: " + string(fps_real));
    // show_debug_message("Platform: " + detect_platform());

    for (var i = 0; i < array_length(sections); i++) {
        var section_name = sections[i];
        var section = global.profiler_data[$ section_name];

        var avg_time = section.total_time / max(section.calls, 1);
        // show_debug_message("  " + section_name + ": " + string(avg_time / 1000) + "ms avg (" + string(section.calls) + " calls)");
    }

    // Reset data for next frame
    global.profiler_data = {};
    global.profiler_frame_start = get_timer();
}

// ===== MAC M2 SPECIFIC PROFILING =====

function profile_depth_sorting() {
    profiler_start("depth_sorting");

    // Count depth-sorted objects
    var depth_objects = instance_number(obj_depth_sorted);

    profiler_end("depth_sorting");

    if (depth_objects > 50 && detect_platform() == "mac") {
        smart_debug_message("⚠️ High object count on Mac: " + string(depth_objects) + " depth-sorted objects");
    }
}

function profile_plant_operations() {
    profiler_start("plant_operations");

    // Profile plant-related operations
    var plant_objects = instance_number(obj_universal_plant);

    profiler_end("plant_operations");

    if (plant_objects > 20 && detect_platform() == "mac") {
        smart_debug_message("⚠️ Many plants on Mac: " + string(plant_objects) + " plants active");
    }
}

function profile_find_operations() {
    profiler_start("find_operations");

    // This will be called whenever we use instance_find

    profiler_end("find_operations");
}

// ===== AUTO PROFILING PER MAC =====

function auto_profile_mac() {
    if (detect_platform() != "mac") return;

    // Enable profiling automatically on Mac if FPS drops
    if (fps_real < 30 && !global.profiler_enabled) {
        profiler_enable();
        // show_debug_message("🚨 Low FPS detected on Mac - enabling profiler");
    }

    // Generate report every 3 seconds if profiling
    if (global.profiler_enabled && global.frame_count % (60 * 3) == 0) {
        profiler_report();
    }
}

// show_debug_message("📊 Profiler system loaded successfully!");