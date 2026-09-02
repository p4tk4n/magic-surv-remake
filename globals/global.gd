extends Node

var xp_scene: PackedScene = preload("res://experience/experience.tscn")
var current_xp_value: float = 1.0
var xp_value_mult: float = 1.0
var player_xp: float = 0
var elite_xp_mult: float = 2.0

var enemy_damage: float = 10.0 #neni scaleable ani nic co je TRAPNEEE

var spells = [ #lowk mozno obsolete, ig ze by slo pouzit keys zo spellbook dictionary v zozname namiesto tohto
	"Magic Bolt",
	"Satellite",
	"Tsunami"
]

var unavailable_spells = []

var spell_data = { #data for spell controllers, basically spell backend
	"Magic Bolt": load("res://spells/resources/magic_bolt/magic_bolt.tres"),
	"Satellite": load("res://spells/resources/satellite/satellite.tres"),
	"Tsunami": load("res://spells/resources/tsunami/tsunami.tres")
}

var spellbook = {     #for upgrade purposes, like an atlas with names: [spell description, spell icon]
	"Magic Bolt": ["blah blah blah", load("res://sprites/magic_bolt_icon_demo.png")],
	"Satellite": ["blah blah blah", load("res://sprites/satellite_icon_demo.png")],
	"Tsunami": ["blah blah blah", load("res://sprites/tsunami_icon_demo.png")]
}

#btw vsetky komenty su moje, hlasim sa do sluzby ja, bajo jajo developer mega ultra max
