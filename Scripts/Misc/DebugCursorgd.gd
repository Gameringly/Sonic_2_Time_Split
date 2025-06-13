extends Node2D

var debugSpeed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("gm_action") or Input.is_action_pressed("gm_action2") or Input.is_action_pressed("gm_action3"):
		debugSpeed = 15
	else:
		debugSpeed = 5
	
	if Input.is_action_pressed("gm_right"):
		position.x += debugSpeed
	elif Input.is_action_pressed("gm_left"):
		position.x -= debugSpeed
	if Input.is_action_pressed("gm_up"):
		position.y -= debugSpeed
	elif Input.is_action_pressed("gm_down"):
		position.y += debugSpeed
