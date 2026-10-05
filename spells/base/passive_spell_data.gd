class_name PassiveSpellData
extends Resource

@export var spell_name: String = "default"

@export_category("Stats")
@export var stat_increase: String
@export var increase_amount: Array[float] = [.05, .1, .15, .2, .25]

var current_level: int = 0

func level_up():
	if current_level < increase_amount.size() - 1:
		current_level += 1
		
	if current_level > increase_amount.size() - 1:
		global.unavailable_upgrades.append(stat_increase)
		return
		
	match global.spellbook.get(spell_name)[2]:
			"mult": global.player_stats.apply_mult(spell_name, increase_amount[current_level])
			"add": global.player_stats.apply_add(spell_name, increase_amount[current_level])
