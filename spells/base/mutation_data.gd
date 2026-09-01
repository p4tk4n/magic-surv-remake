class_name MutationData
extends Resource

@export var mutation_name: String = ""
@export var icon: Texture2D
@export var description: String = ""

@export var projectile_scene: PackedScene
@export var emission_strategy: EmissionStrategy
@export var movement_strategy: MovementStrategy
@export var on_hit_strategy: OnHitStrategy
@export var cooldown: float = -1.0

@export var mutated_stats: SpellLevelData
@export var required_passives: Array[String] = []
