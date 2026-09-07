class_name Upgrade
extends Button

@onready var spell_icon: TextureRect = $MarginContainer/BoxContainer3/SpellIcon
@onready var spell_name: Label = $MarginContainer/BoxContainer3/BoxContainer2/SpellName
@onready var spell_desc: Label = $MarginContainer/BoxContainer3/BoxContainer2/SpellDesc

func set_params(new_icon: Texture2D, new_name: String, new_desc: String) -> void:
	spell_icon.texture = new_icon
	spell_name.text = new_name
	spell_desc.text = new_desc
	queue_redraw()

func _on_pressed() -> void:
	get_parent().get_parent().get_parent().spell_picked.emit(spell_name.text)
