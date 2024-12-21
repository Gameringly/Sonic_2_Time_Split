extends Node2D

@onready var detectWater = $DetectWater

var on_board = false
var player = null
var touching_water = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !touching_water:
		position.y += 1
	if on_board == true:
		position.x = player.position.x
		player.movement.x = 7*60
		if player.any_action_pressed():
			player.set_state(player.STATES.AIR)
			player.movement.y = -4*60
		#else:
			#player.movement.y = 0



func _on_board_body_entered(body: Node2D) -> void:
	player = body
	player.position.x = position.x
	player.position.y = position.y - 18
	player.set_state(player.STATES.NORMAL)
	player.ground = true
	player.animator.play("idle")
	on_board = true


func _on_discard_body_entered(body: Node2D) -> void:
	if player != null:
		on_board = false
		player.set_state(player.STATES.AIR)
		player.movement.y = -4*60
		queue_free()


func _on_detect_water_body_entered(body: Node2D) -> void:
	touching_water = true
