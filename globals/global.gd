extends Node

var xp_scene: PackedScene = preload("res://experience/experience.tscn")
var current_xp_value: float = 1.0
var xp_value_mult: float = 1.0
var player_xp: int = 0

var spells = [
	"Magic Bolt",
	"Satellite",
	"Tsunami"
]

var unavailable_spells = []

var spell_data = {
	"Magic Bolt": load("res://spells/resources/magic_bolt/magic_bolt.tres"),
	"Satellite": load("res://spells/resources/satellite/satellite.tres"),
	"Tsunami": load("res://spells/resources/tsunami/tsunami.tres")
}

var spellbook = {
	"Magic Bolt": ["blah blah blah", load("res://sprites/magic_bolt_icon_demo.png")],
	"Satellite": ["blah blah blah", load("res://sprites/satellite_icon_demo.png")],
	"Tsunami": ["blah blah blah", load("res://sprites/tsunami_icon_demo.png")]
}
