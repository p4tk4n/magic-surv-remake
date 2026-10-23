class_name TrailData
extends Resource

#@export var color: Color = Color.WHITE
@export var gradient: Gradient
@export var width: float = 10.0
@export var width_curve: Curve #graf podla ktoreho sa znizuje/zvysuje width trailu
@export var max_points: int = 20
@export var point_spacing: float = 6.0
@export var texture: Texture2D
@export var texture_mode: Line2D.LineTextureMode = Line2D.LINE_TEXTURE_STRETCH
@export var additional: bool = false
