// Villager NPC - Sarah
// Inherits from obj_npc_base

// Call parent create event
event_inherited();

// Register with NPC system
npc_register(id, "villager");

// Villager-specific initialization
npc_speed = 1.2;
npc_talk_range = 36;

show_debug_message("Villager NPC created: Sarah");