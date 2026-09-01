class_name EmissionStrategy
extends Resource

func emit(controller: SpellController) -> void:
	push_error("EmissionStrategy.emit() not overridden")

func on_removed(controller: SpellController) -> void:
	pass
