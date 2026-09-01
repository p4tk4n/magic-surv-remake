class_name LevelManager
extends Node

@export var ui_xp_bar: Control
@export var ui_control: Control
@onready var upgrade_window_scene = preload("res://upgrades/upgrade_window.tscn")
@onready var spell_manager: SpellManager = $"../SpellManager"

var queued_upgrade_windows: int = 0
var window_open: bool = false

func _ready() -> void:
	SignalBus.run_over.connect(reset)

func reset():
	ui_xp_bar.value = 0.0
	queued_upgrade_windows = 0
	window_open = false
	
func level_up_player():
	ui_xp_bar.value = 0.0
	trigger_upgrade_window()

func progress_xp_bar(mult):
	var xp_added = global.current_xp_value * global.xp_value_mult * mult
	ui_xp_bar.value += xp_added
	global.player_xp += xp_added

func trigger_upgrade_window():
	if window_open:
		queued_upgrade_windows += 1
		print("didnt open window")
	else:
		var upgrade_window = upgrade_window_scene.instantiate()
		upgrade_window.spell_picked.connect(show_next_window)
		ui_control.add_child(upgrade_window)
		window_open = true
		upgrade_window.shuffle_spells()

func _upgrade_picked_spell(spell_name: String):
	if spell_manager.active_spells.has(spell_name):
		spell_manager.upgrade_spell(spell_name)
	else:
		spell_manager.add_spell(global.spell_data.get(spell_name))
	
func show_next_window(spell):
	_upgrade_picked_spell(spell)
	get_tree().get_first_node_in_group("upgradewindow").queue_free()
	window_open = false
	if queued_upgrade_windows > 0:
		trigger_upgrade_window()
		queued_upgrade_windows -= 1	
