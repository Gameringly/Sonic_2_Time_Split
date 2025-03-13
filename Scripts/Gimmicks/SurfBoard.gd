extends CharacterBody2D

var active = false
var player = null
var doOnce = false
var despawnTimer = 300

@onready var sprite = $Sprite2D
@onready var detectPlayer = $DetectPlayer

func _physics_process(delta: float) -> void:
	if player != null:
		if active and player.currentState != player.STATES.SURFING:
			if !doOnce:
				global_position = player.global_position
				sprite.visible = true
				velocity.y = -300
				velocity.x = -100
				doOnce = true
			sprite.rotation -= PI*delta*10
			translate(velocity*delta)
			velocity.y += player.grv/GlobalFunctions.div_by_delta(delta)
			despawnTimer -= 1
			if despawnTimer <= 0:
				queue_free()

func _on_detect_player_body_entered(body: Node2D) -> void:
	player = body
	player.position = Vector2(position.x,position.y-16)
	player.movement.y = -4*60
	player.movement.x = 4*60
	player.animator.play("surfing")
	sprite.visible = false
	detectPlayer.set_deferred("monitoring", false)
	player.set_state(player.STATES.SURFING)
	active = true
