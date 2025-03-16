extends Area2D

@onready var path = $Path2D
@onready var follow = $Path2D/PathFollow2D
@onready var remote = $Path2D/PathFollow2D/RemoteTransform2D
@onready var animator = $AnimationPlayer
@onready var collision = $CollisionShape2D
@onready var timer = $InactiveTimer

var player = null
var enterSpeed = 0
var stopHolding = false
var direction

func _physics_process(delta: float) -> void:
	if player != null and !stopHolding:
		player.movement.x = 0
		player.movement.y = 0

func _on_body_entered(body: Node2D) -> void:
	direction = body.direction
	path.scale.x = direction
	#collision.disabled = true
	collision.set_deferred("disabled",true)
	stopHolding = false
	player = body
	enterSpeed = abs(body.movement.x/60)
	if enterSpeed < 2:
		enterSpeed = 2
	print(enterSpeed)
	body.currentState = body.STATES.AIR
	remote.remote_path = body.get_path()
	animator.speed_scale = enterSpeed/2
	animator.play("Fling")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Fling":
		stopHolding = true
		player.movement.x = (-enterSpeed*60) * direction
		player.movement.y = -enterSpeed*60
		player = null
		timer.start()


func _on_inactive_timer_timeout() -> void:
	#collision.disabled = false
	collision.set_deferred("disabled",false)
