extends Area2D

@onready var path = $Path2D
@onready var follow = $Path2D/PathFollow2D
@onready var remote = $Path2D/PathFollow2D/RemoteTransform2D
@onready var animator = $AnimationPlayer
@onready var collision = $CollisionShape2D
@onready var timer = $InactiveTimer

@export var FlingHeight = 10
@export var FlingDistance = 0

var player = null
var stopHolding = false
var direction

func _physics_process(delta: float) -> void:
	if player != null and !stopHolding:
		player.movement.x = 0
		player.movement.y = 0
		if player.animator.current_animation != "roll":
			player.animator.play("roll")

func _on_body_entered(body: Node2D) -> void:
	#collision.disabled = true
	collision.set_deferred("disabled",true)
	stopHolding = false
	player = body
	body.set_state(body.STATES.AIR)
	body.animator.play("roll")
	remote.remote_path = body.get_path()
	animator.speed_scale = FlingHeight/5 + FlingDistance/5
	$Grab.play()
	animator.play("Fling")
	$Root.play("Fling")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Fling":
		stopHolding = true
		$Fling.play()
		# figure out the animation based on the players current animation
		var curAnim = "walk"
		match(player.animator.current_animation):
			"walk", "run", "peelOut":
				curAnim = player.animator.current_animation
			# if none of the animations match and speed is equal beyond the players top speed, set it to run (default is walk)
			_:
				if(abs(player.groundSpeed) >= min(6*60,player.top)):
					curAnim = "run"
		# play player animation
		player.animator.play("spring")
		if player.character == Global.CHARACTERS.AMY:
			player.animator.queue("fall")
		else:
			player.animator.queue(curAnim)
		player.movement.y = -FlingHeight*60
		if FlingDistance != 0:
			player.movement.x = FlingDistance*60 * scale.x
		player = null
		remote.remote_path = ""
		timer.start()


func _on_inactive_timer_timeout() -> void:
	#collision.disabled = false
	collision.set_deferred("disabled",false)
