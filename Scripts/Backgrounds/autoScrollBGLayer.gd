extends ParallaxLayer

@export var scroll_speed = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	motion_offset.x -= scroll_speed
