// Carica gli oggetti salvati per qualsiasi room
load_room_objects(room);

if (variable_instance_exists(id, "has_transition_target") && self.has_transition_target) {
    x = self.target_x;
    y = self.target_y;
    self.has_transition_target = false;
    global.disable_pushout = true;
    alarm[0] = 5;
    alarm[1] = 10;
}