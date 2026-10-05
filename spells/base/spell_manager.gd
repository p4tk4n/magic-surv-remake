class_name SpellManager
extends Node

var player: Node2D
var active_spells: Dictionary = {}  # String -> SpellController
var passive_spells: Dictionary[String,PassiveSpellData] = {}

func _ready() -> void:
	player = get_parent()  # assumes SpellManager is a direct child of Player

func add_spell(data) -> void:
	var type = "passive" if data.spell_name in global.passive_upgrades else "active"
	#print("Current spell is (passive,active): ", type)
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
		#print("Current spell is (mult,add): ", global.spellbook.get(data.spell_name)[2])
		match global.spellbook.get(data.spell_name)[2]:
			"mult": global.player_stats.apply_mult(data.spell_name, data.increase_amount[data.current_level])
			"add": global.player_stats.apply_add(data.spell_name, data.increase_amount[data.current_level])
		
func reset() -> void:
	for controller in active_spells.values():
		if is_instance_valid(controller):
			controller.clear_projectiles()
			controller.queue_free()
		
	active_spells.clear()
	passive_spells.clear()

func upgrade_spell(spell_name: String) -> void:
	if active_spells.has(spell_name):
		active_spells[spell_name].level_up()
	elif passive_spells.has(spell_name):
		passive_spells[spell_name].level_up()
		
func get_spell_level(spell_name: String) -> int:
	if 	active_spells.has(spell_name):
		#print(active_spells.get(spell_name).level)
		return active_spells[spell_name].level
	else:
		return -1
		
