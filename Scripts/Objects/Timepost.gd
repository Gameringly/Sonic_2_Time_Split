@tool
extends Area2D
var active = false
@export_enum("Past", "Future") var TimePeriod = 0

@onready var post = $Post
@onready var animator = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	post.frame = TimePeriod

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		post.frame = TimePeriod
		

func _on_body_entered(body: Node2D) -> void:
	if !active:
		if body.playerControl == 1:
			active = true
			if TimePeriod == 0:
				animator.play("PastSpin") #spin the post
				$PAST.play() #play the sfx
				body.timeWarp = "Past" #set the time period to travel to
				body.get_parent().hud.timePlate.play("Past") #display the plate on the hud
			elif TimePeriod == 1:
				animator.play("FutureSpin")
				$FUTURE.play()
				body.timeWarp = "Future"
				body.get_parent().hud.timePlate.play("Future")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "PastSpin":
		post.frame = 5
	elif anim_name == "FutureSpin":
		post.frame = 6
