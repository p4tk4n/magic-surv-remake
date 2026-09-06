class_name SpellManager
extends Node

var player: Node2D
var active_spells: Dictionary = {}  # String -> SpellController
var passive_spells: Dictionary[String,PassiveSpellData] = {}

func _ready() -> void:
	player = get_parent()  # assumes SpellManager is a direct child of Player

func add_spell(data) -> void:
	var type = "passive" if data.spell_name in global.passive_upgrades else "active"
	if type == "active":
		if active_spells.has(data.spell_name):
			return
		var controller := SpellController.new()
		add_child(controller)
		controller.setup(data, player)
		active_spells[data.spell_name] = controller
	elif type == "passive":
		if passive_spells.has(data.spell_name):
			return
		passive_spells[data.spell_name] = data

func reset() -> void:
	for controller in active_spells.values():
		controller.queue_free()
		
	active_spells.clear()
	passive_spells.clear()

func upgrade_spell(spell_name: String) -> void:
	if active_spells.has(spell_name):
		active_spells[spell_name].level_up()
	elif passive_spells.has(spell_name):
		passive_spells[spell_name].current_level += 1
	
func get_spell_level(spell_name: String) -> int:
	if 	active_spells.has(spell_name):
		print(active_spells.get(spell_name).level)
		return active_spells[spell_name].level
	else:
		return -1
		
