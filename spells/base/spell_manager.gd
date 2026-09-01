class_name SpellManager
extends Node

var player: Node2D
var active_spells: Dictionary = {}  # String -> SpellController

func _ready() -> void:
	player = get_parent()  # assumes SpellManager is a direct child of Player

func add_spell(data: SpellData) -> void:
	if active_spells.has(data.spell_name):
		return
	var controller := SpellController.new()
	add_child(controller)
	controller.setup(data, player)
	active_spells[data.spell_name] = controller

func reset() -> void:
	for controller in active_spells.values():
		controller.queue_free()
	active_spells.clear()

func upgrade_spell(spell_name: String) -> void:
	if active_spells.has(spell_name):
		active_spells[spell_name].level_up()

func get_spell_level(spell_name: String) -> int:
	if 	active_spells.has(spell_name):
		print(active_spells.get(spell_name).level)
		return active_spells[spell_name].level
	else:
		return -1
		
