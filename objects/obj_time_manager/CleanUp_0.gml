// Cleanup delle data structures
if (variable_instance_exists(id, "time_colors") && ds_exists(time_colors, ds_type_map)) {
    ds_map_destroy(time_colors);
}