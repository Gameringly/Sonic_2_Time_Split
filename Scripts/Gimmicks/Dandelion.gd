extends Area2D

@onready var timer = $Timer

var flying = false
var speed = 0
var player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if flying:
		player.movement = speed
		position = Vector2(player.position.x, player.position.y+30)
		if player.horizontalSensor.is_colliding() or (player.ground and player.movement.y > 0) or player.movement != speed:
			flying = false
			queue_free()
		
		if player.any_action_pressed():
			flying = false
			player.action_jump()
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body == Global.players[0]:
		player = body
		speed = player.movement.rotated(player.angle-player.gravityAngle)
		flying = true
		timer.start()
		player.set_state(player.STATES.AIR)
	elif flying:
		flying = false
		queue_free()
	


func _on_timer_timeout() -> void:
	flying = false
	queue_free()
	
