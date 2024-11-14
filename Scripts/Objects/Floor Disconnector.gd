extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	body.currentState = body.STATES.AIR
	body.disconect_from_floor()


func _on_switch_4_pressed() -> void:
	queue_free()
