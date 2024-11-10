extends StaticBody2D

@export var waterSurface = [preload("res://Graphics/Gimmicks/WaterSurface1.png"),preload("res://Graphics/Gimmicks/WaterSurface2.png")]

var frame = 0
@export var animSpeed = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Animation
	frame += delta*animSpeed
	frame = wrapf(frame,0,waterSurface.size())
	
	$Water.texture = waterSurface[floor(frame)]


func _on_rotation_body_entered(body):
	body.splash_rotation = rotation
