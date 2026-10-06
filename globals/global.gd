extends CanvasLayer

var current_xp_value: float = 1.0
var xp_value_mult: float = 1.09
var player_xp: float = 0
var elite_xp_mult: float = 2.0
var level_xpreq_increase: float = 1.08

var player_stats: PlayerStats = load("res://player/stats.tres")
var enemy_damage: float = 10.0 #neni scaleable ani nic co je TRAPNEEE

var camera_rect_cache: Rect2
var camera_rect_bounds: float = 300.0

var joystick_scales = [200.0,300.0,400.0]
var current_joystick_size: int = 1

var window_size_pc := Vector2i(1000,1000)
var window_size_mobile := Vector2i(1000,2000)

var current_scene: PackedScene
var previous_scene: PackedScene
var game_paused: bool = false

var scenes: Dictionary = {
	"main_menu": load("res://menus/main_menu.tscn"),
	"settings": load("res://menus/settings_menu.tscn"),
	"map": load("res://map/map.tscn")
}

var upgrades
var passive_upgrades = [
	"Wisdom",
	"Pickup Area"
]

var unavailable_upgrades = []

var spell_data = { #data for spell controllers, basically spell backend
	"Magic Bolt": load("res://spells/resources/magic_bolt/magic_bolt.tres"),
	"Satellite": load("res://spells/resources/satellite/satellite.tres"),
	"Tsunami": load("res://spells/resources/tsunami/tsunami.tres"),
	"Fireball": load("res://spells/resources/fireball/fireball.tres"),
	"Wisdom": load("res://spells/resources/Passives/wisdom.tres"),
	"Pickup Area": load("res://spells/resources/Passives/pickup_area.tres")
}

var spellbook = {     #for upgrade purposes, like an atlas with names: [spell description, spell icon]
	"Magic Bolt": ["The default projectile", load("res://spells/resources/magic_bolt/magic_bolt.tres").icon],
	"Satellite": ["An orbiting orb", load("res://spells/resources/satellite/satellite.tres").icon],
	"Tsunami": ["A sweeping wave", load("res://spells/resources/tsunami/tsunami.tres").icon],
	"Fireball": ["An exploding ball of fire", load("res://spells/resources/fireball/fireball.tres").icon],
	"Lightning": ["A bolt of electricity strikes down", load("res://spells/resources/lightning/lightning.tres").icon],
	"Wisdom": ["Damage % increase", load("res://sprites/wisdom_icon_demo.png"), "mult"],
	"Pickup Area": ["Area increases", load("res://sprites/pickup_area_icon.png"), "mult"]
	
}

#btw vsetky komenty su moje, hlasim sa do sluzby ja, bajo jajo developer mega ultra max
#yeah stale goin hard komentujem tu shit 

func _ready() -> void:
	upgrades = get_upgrades_arr("res://spells/resources/")
	spell_data = get_spell_data("res://spells/resources/", upgrades, passive_upgrades)
	layer = 100
	
func switch_scene(new_scene: PackedScene) -> void:
	previous_scene = current_scene
	current_scene = new_scene
	pause_game(false)
	get_tree().change_scene_to_packed.call_deferred(current_scene)

func open_scene(overlay_scene: PackedScene) -> void:
	print("opening scene")
	var instance = overlay_scene.instantiate()
	add_child(instance)
	pause_game(true)
	instance.tree_exited.connect(func(): pause_game(false))

func pause_game(paused: bool) -> void:
	game_paused = paused
	get_tree().paused = game_paused
	
func _process(delta: float) -> void:
	camera_rect_cache = _calc_camera_rect()
	
func _calc_camera_rect():
	var cam = get_viewport().get_camera_2d()
	if not cam: return Rect2()
	
	var viewport_size = get_viewport().get_visible_rect().size
	var zoom = cam.zoom
	var half_size = (viewport_size / zoom) / 2
	
	return Rect2(cam.global_position - half_size, half_size * 2.0)

#var upgrades = [ #lowk mozno obsolete, ig ze by slo pouzit keys zo spellbook dictionary v zozname namiesto tohto
	#"Magic Bolt",
	#"Satellite",
	#"Tsunami",
	#"Fireball",
	#
#]

func get_spell_data(path, upgrades, passives):
	var output = {}
	for name in upgrades:
		var file_path = str(path) + str(_unformat_spellname(name)) + "/" +  str(_unformat_spellname(name)) + ".tres"
		output[name] = load(file_path)
		
	for name in passives:
		var file_path = str(path) + "Passives/" +  str(_unformat_spellname(name)) + ".tres"
		output[name] = load(file_path)
	return output
	
func get_upgrades_arr(path):
	var output_names: Array = []
	for name: String in DirAccess.get_directories_at(path):
		output_names.append(_format_spellname(name))
	output_names.erase("Passives")
	return output_names

func _format_spellname(name: String) -> String:
	return name.replace("_", " ").capitalize()

func _unformat_spellname(name: String) -> String:
	return name.to_lower().replace(" ", "_")
