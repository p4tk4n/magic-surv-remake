extends Panel

@onready var box_container: BoxContainer = $BoxContainer
@onready var upgrade_scene: PackedScene = preload("res://upgrades/upgrade.tscn")
signal spell_picked(spell)

func shuffle_spells():
	var available_spells: Array = Helpers.subtract_array(global.spells, global.unavailable_spells)
	available_spells.shuffle()
	print(available_spells)
	
	if box_container.get_children().size() < 3:
		var upgrade_instance = upgrade_scene.instantiate()
		box_container.add_child(upgrade_instance)
		print("dead child making new one")
		
	for child: Upgrade in box_container.get_children():
		if available_spells.size() >= 1:
			var rand_spell = available_spells.front()
			print(rand_spell)
			child.set_params(
				global.spellbook[rand_spell][1],
				rand_spell,
				global.spellbook[rand_spell][0]
			)
			available_spells.pop_front()
		else:
			child.queue_free()
