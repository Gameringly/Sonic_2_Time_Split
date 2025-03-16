extends Area2D

var player = null

func _physics_process(delta: float) -> void:
	if player != null:
		if player.any_action_pressed():
			$TrickHit.play()
			player.movement.x = 12*60
			player.movement.y = -6*60
			player = null

func _on_body_entered(body: Node2D) -> void:
	if body.currentState == body.STATES.SURFING:
		player = body
		player.movement.y = -4*60
		$TrickFail.play()


func _on_body_exited(body: Node2D) -> void:
	player = null
