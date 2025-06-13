extends Area2D

@onready var timer = $Timer
@onready var cover = $Cover

var flying = false
var speed = 0
var player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if flying:
		player.movement = speed
		if player.direction >= 1:
			position = Vector2(player.position.x+2, player.position.y+20)
		else:
			position = Vector2(player.position.x-16, player.position.y+20)
		cover.modulate.a = timer.time_left / 1.5
		if player.animator.current_animation != "dandelion":
			player.animator.play("dandelion")
		if player.horizontalSensor.is_colliding() or (player.ground and player.movement.y > 0) or player.movement != speed:
			player.animator.play("roll")
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
		player.animator.play("roll")
		flying = false
		queue_free()
	


func _on_timer_timeout() -> void:
	player.animator.play("roll")
	flying = false
	queue_free()
	
