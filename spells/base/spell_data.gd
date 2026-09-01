class_name SpellData
extends Resource
@export_category("Base")
@export var spell_name: String = ""
@export var icon: Texture2D
@export var projectile_scene: PackedScene
@export var projectile_sprite: Texture2D
@export var cooldown: float = 1.0
@export var levels: Array[SpellLevelData] = []
@export var is_persistent: bool = false

@export_category("Strategies")
@export var emission_strategy: EmissionStrategy
@export var movement_strategy: MovementStrategy
@export var on_hit_strategy: OnHitStrategy

@export var mutation: MutationData
