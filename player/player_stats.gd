class_name PlayerStats
extends Resource

@export var stats: Dictionary = {
	"Wisdom" = 10.0,
	"damage_amplifier" = 1.0,
	"damage_increase" = 0.0,
	"damage_coefficient" = 1.0,
	
	"Size Increase" = 1.0,
	"Duration Increase" = 1.0,
	
	"Health" = 100.0,
	"Healing" = 0.0, #in %
	"Health Increase" = 1.0, #in % too, actualyl most of this is % type
	
	"Move Speed" = 220.0,
	"Pickup Area" = 128.0
}

signal stat_changed(stat_name: String, new_value: float)

func apply_mult(stat_name: String, mult: float):
	print("Mult for ", stat_name, " is +", mult*100, "%")
	stats[stat_name] *= (1.0 + mult)
	print(stats)
	stat_changed.emit(stat_name, stats[stat_name])

func apply_add(stat_name: String, amount: float):
	stats[stat_name] += amount
	stat_changed.emit(stat_name, stats[stat_name])
