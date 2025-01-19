extends Node2D

# 0 = normal, 1 = medium, 2 = airbubble
var bubbleType = 0

var velocity = Vector2(1,-32)
@onready var offsetTime = randf()*4
@onready var bubble = $Bubble
var maxDistance = 0

func _ready():
	bubble.frame = 0
	match(bubbleType):
		0:
			bubble.play("default")
		1:
			bubble.play("medium")
		2:
			bubble.play("air")
			$BubbleCollect/CollisionShape2D.disabled = false

# queue if popped
func _on_Bubble_animation_finished():
	if bubble.animation == "bigPop":
		queue_free()

func _physics_process(delta):
	# check if below water level and rise
	if (global_position.y > maxDistance or maxDistance == 0):
		translate(velocity*delta)
		offsetTime += delta
		velocity.x = cos(offsetTime*4)*8
		# slow down y velocity if approaching max distance
		if maxDistance != 0:
			if abs(maxDistance-global_position.y) < abs(velocity.y/2.0):
				velocity.y = min(-32,(maxDistance-global_position.y)*2.0)
	else:
		# if big bubble then play popping animation
		if bubble.animation == "air":
			bubble.play("bigPop")
			set_physics_process(false)
			$BubbleCollect/CollisionShape2D.disabled = true
		else:
			queue_free()

# player collect bubble
func _on_BubbleCollect_body_entered(body):
	# player get air, ignore if they're already in a bubble
	if !body.ground and bubble.frame >= 6 and body.shield != body.SHIELDS.BUBBLE:
		body.airTimer = body.defaultAirTime
		body.sfx[23].play()
		
		body.set_state(body.STATES.AIR)
		body.animator.play("air")
		body.animator.queue("walk")
		body.movement = Vector2.ZERO
		bubble.play("bigPop")
		#$BubbleCollect/CollisionShape2D.call_deferred("set","disabled",true)
		set_physics_process(false)

# clear if off screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
