// Merchant NPC - Trader Joe
// Inherits from obj_npc_base

// Call parent create event
event_inherited();

// Register with NPC system
npc_register(id, "merchant");

// Merchant-specific initialization
npc_speed = 0.8;
npc_talk_range = 32;

show_debug_message("Merchant NPC created: Trader Joe");