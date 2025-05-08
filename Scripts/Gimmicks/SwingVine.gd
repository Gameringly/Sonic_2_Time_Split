extends Area2D

@onready var path = $Path2D
@onready var follow = $Path2D/PathFollow2D
@onready var remote = $Path2D/PathFollow2D/RemoteTransform2D
@onready var animator = $AnimationPlayer
@onready var collision = $CollisionShape2D
@onready var timer = $InactiveTimer
@onready var vine = $Vine

@export var FlingHeight = 0.0
@export var FlingDistance = 0.0

var player = null
var stopHolding = false
var direction

func _physics_process(delta: float) -> void:
	if player != null and !stopHolding:
		player.movement.x = 0
		player.movement.y = 0
		if player.animator.current_animation != "roll":
			player.animator.play("roll")
		
		#jump off the vine
		if player.any_action_pressed():
			player.movement.y = FlingHeight*60
			player.movement.x = FlingDistance*60 * scale.x
			timer.start()
			animator.stop()
			stopHolding = true
			remote.remote_path = ""
			player = null

func _on_body_entered(body: Node2D) -> void:
	#collision.disabled = true
	collision.set_deferred("disabled",true)
	stopHolding = false
	direction = body.direction
	scale.x = sign(body.movement.x)
	player = body
	body.set_state(body.STATES.AIR)
	body.animator.play("roll")
	remote.remote_path = body.get_path()
	#animator.speed_scale = FlingHeight/5 + FlingDistance/5
	$Grab.play()
	animator.play("Fling")
	vine.play("Fling")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	scale.x = -scale.x
	animator.play("Fling")
	if stopHolding == true:
		vine.play("RESET")
	else:
		vine.play("Fling")


func _on_inactive_timer_timeout() -> void:
	#collision.disabled = false
	collision.set_deferred("disabled",false)


func _on_tree_exited() -> void:
	player = null
	remote.remote_path = ""
	collision.set_deferred("disabled",false)
	animator.stop()
	if vine:
		vine.stop()
	
