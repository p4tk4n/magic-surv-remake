extends Panel

@onready var box_container: BoxContainer = $BoxContainer
@onready var upgrade_scene: PackedScene = preload("res://upgrades/upgrade.tscn")
signal spell_picked(spell)

func shuffle_spells():
	var upgrades_and_spells: Array = Helpers.add_array(global.upgrades, global.passive_upgrades)
	var available_upgrades: Array = Helpers.subtract_array(upgrades_and_spells, global.unavailable_upgrades)
	
	var actives: Array = Helpers.subtract_array(global.upgrades, global.unavailable_upgrades)
	var passives: Array = Helpers.subtract_array(global.passive_upgrades, global.unavailable_upgrades)
	
	print("global.upgrades: ", global.upgrades)
	print("global.passive_upgrades: ", global.passive_upgrades)
	print("global.unavailable_upgrades: ", global.unavailable_upgrades)
	print("actives after subtract: ", actives)
	print("passives after subtract: ", passives)
	
	while box_container.get_children().size() < 3:
		var upgrade_instance = upgrade_scene.instantiate()
		box_container.add_child(upgrade_instance)
	
	for child: Upgrade in box_container.get_children():
		if available_upgrades.size() >= 1:
			available_upgrades.shuffle()
			var rand_spell = available_upgrades.pop_front()
			print(rand_spell)
			child.set_params(
				global.spellbook[rand_spell][1],
				rand_spell,
				global.spellbook[rand_spell][0]
			)
		else:
			child.queue_free()
