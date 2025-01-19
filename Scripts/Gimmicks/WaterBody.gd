extends Area2D

var Particle = preload("res://Entities/Misc/GenericParticle.tscn")
@onready var shape = $WaterShape
@onready var cover = $WaterShape/Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cover.polygon = shape.polygon

func _on_body_entered(body):
	if body.get_collision_layer_value(13):
		if body.currentState != body.STATES.DIE:
			if !body.water:
				body.action_water_run_handle()
				body.water = true
				body.switch_physics()
				body.movement.x *= 0.5
				body.movement.y *= 0.25
				if body.currentState != body.STATES.RESPAWN:
					body.sfx[17].play()
					var splash = Particle.instantiate()
					splash.behaviour = splash.TYPE.FOLLOW_WATER_SURFACE
					splash.rotation = body.splash_rotation
					#this is close enough, could be improved
					if splash.rotation != 0 and splash.rotation != 180:
						splash.global_position = Vector2(body.global_position.x - (body.movement.x/15), body.global_position.y - (body.movement.y/15))
					else:
						splash.global_position = Vector2(body.global_position.x,body.global_position.y - (body.movement.y/15))
					splash.play("Splash")
					splash.z_index = body.sprite.z_index+10
					get_parent().add_child(splash)


func _on_body_exited(body):
	if body.get_collision_layer_value(13):
		if body.currentState != body.STATES.DIE:
			if body.water:
				body.water = false
				body.switch_physics()
				body.movement.y *= 2
				body.sfx[17].play()
				var splash = Particle.instantiate()
				splash.behaviour = splash.TYPE.FOLLOW_WATER_SURFACE
				splash.rotation = body.splash_rotation
				if splash.rotation != 0 and splash.rotation != 180:
					splash.global_position = Vector2(body.global_position.x - (body.movement.x/60), body.global_position.y - (body.movement.y/60))
				else:
					splash.global_position = Vector2(body.global_position.x,body.global_position.y - (body.movement.y/60)) #this is close enough, could be improved
				splash.play("Splash")
				splash.z_index = body.sprite.z_index+10
				get_parent().add_child(splash)


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Bubbles"):
		if area.get_parent().bubble.animation == "air":
			area.get_parent().bubble.play("bigPop")
		else:
			area.get_parent().queue_free()
