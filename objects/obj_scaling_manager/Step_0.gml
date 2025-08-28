// Applica scale solo al primo frame
if (!scales_applied) {
    var pickup_layer = layer_get_id("pickupable");
    if (pickup_layer != -1) {
        var layer_elements = layer_get_all_elements(pickup_layer);
        
        for (var i = 0; i < array_length(layer_elements); i++) {
            var element = layer_elements[i];
            
            if (layer_get_element_type(element) == layerelementtype_sprite) {
                var element_sprite = layer_sprite_get_sprite(element);
                var sprite_name = sprite_get_name(element_sprite);
                var scale_data = get_sprite_scale(sprite_name);
                
                layer_sprite_xscale(element, scale_data.scale_x);
                layer_sprite_yscale(element, scale_data.scale_y);
                
                show_debug_message("📏 Applicata scala a " + sprite_name + ": " + string(scale_data.scale_x));
            }
        }
        scales_applied = true;
        show_debug_message("📏 Scale applicate a tutti gli sprite");
    }
}