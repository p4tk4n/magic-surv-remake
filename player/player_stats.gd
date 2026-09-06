class_name PlayerStats
extends Resource

@export var stats: Dictionary = {
	"base_attack" = 10.0,
	"damage_amplifier" = 1.0,
	"damage_increase" = 0.0,
	"damage_coefficient" = 1.0,
	
	"spell_size_mult" = 1.0,
	"spell_duration_mult" = 1.0,
	
	"base_health" = 100.0,
	"passive_healing" = 0.0, #in %
	"health_increase" = 1.0, #in % too, actualyl most of this is % type
	
	"base_move_speed" = 220.0
}
