extends Node2D

@onready var sprite = $Sprite
@onready var hitbox = $Hitbox
@onready var sparkles = $Sprite/Sparkles

@export var collected = false

var level = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = get_parent()

func _physics_process(delta: float) -> void:
	if level:
		if level.has_node("Present"):
			visible = true
			sparkles.visible = false
			sprite.play("Present")
			hitbox.monitoring = false
		elif level.has_node("Past"):
			visible = true
			sparkles.visible = true
			sprite.play("Past")
			hitbox.monitoring = true
		else:
			visible = false
			hitbox.monitoring = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	body.sfx[33].play()
	var part = body.Particle.instantiate()
	part.global_position = global_position
	part.z_index = 10
	part.play("TimeStar")
	get_parent().add_child(part)
	level.gotTimeStone = true
	collected = true
	queue_free()
