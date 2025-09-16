// Farmer NPC - Old Tom
// Inherits from obj_npc_base

// Call parent create event
event_inherited();

// Register with NPC system
npc_register(id, "farmer");

// Farmer-specific initialization
npc_speed = 1;
npc_talk_range = 40;

show_debug_message("Farmer NPC created: Old Tom");