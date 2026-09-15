extends Node

var xp_scene: PackedScene = preload("res://experience/experience.tscn")
var current_xp_value: float = 1.0
var xp_value_mult: float = 1.0
var player_xp: float = 0
var elite_xp_mult: float = 2.0

var player_stats: PlayerStats = load("res://player/stats.tres")

var enemy_damage: float = 10.0 #neni scaleable ani nic co je TRAPNEEE

var camera_rect_cache: Rect2
var camera_rect_bounds: float = 300.0

var joystick_scales = [200.0,300.0,400.0]
var current_joystick_size: int = 1

var window_size_pc := Vector2i(1000,1000)
var window_size_mobile := Vector2i(1000,2000)

var scenes: Dictionary = {
	"main_menu": load("res://menus/main_menu.tscn"),
	"settings": load("res://menus/settings_menu.tscn"),
	"map": load("res://map/map.tscn")
}

func _process(delta: float) -> void:
	camera_rect_cache = _calc_camera_rect()
	
func _calc_camera_rect():
	var cam = get_viewport().get_camera_2d()
	if not cam: return Rect2()
	
	var viewport_size = get_viewport().get_visible_rect().size
	var zoom = cam.zoom
	var half_size = (viewport_size / zoom) / 2
	
	return Rect2(cam.global_position - half_size, half_size * 2.0)
	
var upgrades = [ #lowk mozno obsolete, ig ze by slo pouzit keys zo spellbook dictionary v zozname namiesto tohto
	"Magic Bolt",
	"Satellite",
	"Tsunami",
	"Fireball"
]

var passive_upgrades = [
	"Wisdom"
]

var unavailable_upgrades = []

var spell_data = { #data for spell controllers, basically spell backend
	"Magic Bolt": load("res://spells/resources/magic_bolt/magic_bolt.tres"),
	"Satellite": load("res://spells/resources/satellite/satellite.tres"),
	"Tsunami": load("res://spells/resources/tsunami/tsunami.tres"),
	"Fireball": load("res://spells/resources/fireball/fireball.tres"),
	"Wisdom": load("res://spells/resources/Passives/wisdom.tres")
}

var spellbook = {     #for upgrade purposes, like an atlas with names: [spell description, spell icon]
	"Magic Bolt": ["The default projectile", load("res://spells/resources/magic_bolt/magic_bolt.tres").icon],
	"Satellite": ["An orbiting orb", load("res://spells/resources/satellite/satellite.tres").icon],
	"Tsunami": ["A sweeping wave", load("res://spells/resources/tsunami/tsunami.tres").icon],
	"Fireball": ["An exploding ball of fire", load("res://spells/resources/fireball/fireball.tres").icon],
	"Wisdom": ["Damage % increase", load("res://sprites/wisdom_icon_demo.png")]
}

#btw vsetky komenty su moje, hlasim sa do sluzby ja, bajo jajo developer mega ultra max
