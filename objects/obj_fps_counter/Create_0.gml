// FPS Counter - Debug performance in tempo reale
depth = -11000;  // FPS counter - layer Meta

// Variables per FPS tracking
fps_current = 60;
fps_history = [];
fps_smooth = 60;
update_timer = 0;

// Visual settings
fps_color = c_white;
fps_x = 10;
fps_y = 10;

// Performance thresholds
fps_good = 50;
fps_warning = 30;
fps_critical = 20;

// Platform info
// platform_name = detect_platform();
platform_name = "mac"; // Temporary fix

// FPS Counter created (no debug output)