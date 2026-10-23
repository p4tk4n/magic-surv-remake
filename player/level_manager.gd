class_name LevelManager
extends Node

@export var ui_xp_bar: Control
@export var ui_control: Control
@onready var upgrade_window_scene = preload("res://upgrades/upgrade_window.tscn")
@onready var spell_manager: SpellManager = $"../SpellManager"

var queued_upgrade_windows: int = 0
var window_open: bool = false

var xp: float = 0.0
var xp_req: float = 10.0
var xp_tween: Tween

func _ready() -> void:
	SignalBus.run_over.connect(reset)

func reset():
	ui_xp_bar.value = 0.0
	queued_upgrade_windows = 0
	window_open = false
	for child in get_children():
		child.queue_free()
	
func level_up_player():
	if not global.can_level_up: return
	if global.player_level < 100:
		global.player_level += 1
	else:
		global.can_level_up = false
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(ui_xp_bar, "value", 0.0, 0.6)
	trigger_upgrade_window()
	ui_xp_bar.max_value = ui_xp_bar.max_value * global.level_xpreq_increase
	
func progress_xp_bar(mult):
	var xp_added = global.current_xp_value * mult
	global.player_xp += xp_added
	xp += xp_added
	
	while xp >= xp_req:
		xp -= xp_req
		xp_req *= global.level_xpreq_increase
		trigger_upgrade_window()
	
	_animate_bar()

func _animate_bar():
	if xp_tween: xp_tween.kill()
	ui_xp_bar.max_value = xp_req
	xp_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	xp_tween.tween_property(ui_xp_bar, "value", xp, 0.45)
		
func trigger_upgrade_window():
	if window_open:
		queued_upgrade_windows += 1
	else:
		var upgrade_window = upgrade_window_scene.instantiate()
		upgrade_window.spell_manager_ref = spell_manager
		get_tree().paused = true
		upgrade_window.spell_picked.connect(show_next_window)
		ui_control.add_child(upgrade_window)
		window_open = true
		upgrade_window.shuffle_spells()

func _upgrade_picked_spell(spell_name: String):
	if spell_manager.active_spells.has(spell_name) or spell_manager.passive_spells.has(spell_name):
		spell_manager.upgrade_spell(spell_name)
		print("found spell, here are the passives: ",spell_manager.passive_spells)
	else:
		print("didnt find ",spell_name, " in active or passive spells, here are the passives: ",spell_manager.passive_spells)
		spell_manager.add_spell(global.spell_data.get(spell_name))

func show_next_window(spell):
	_upgrade_picked_spell(spell)
	get_tree().get_first_node_in_group("upgradewindow").queue_free()
	get_tree().paused = false
	window_open = false
	if queued_upgrade_windows > 0:
		trigger_upgrade_window()
		queued_upgrade_windows -= 1	
