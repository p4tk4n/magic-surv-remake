class_name PassiveSpellData
extends Resource

@export var spell_name: String = "default"

@export_category("Stats")
@export var stat_increase: String
@export var increase_amount: Array = [5,10,15,20,25]

var current_level: int = 0
