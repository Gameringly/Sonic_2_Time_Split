extends PlayerState


func _physics_process(delta: float) -> void:
	parent.z_index = 16
	parent.action_water_run_handle()
	if parent.sprite.flip_h == true:
		parent.sprite.flip_h = false
	#air movement
	if !parent.ground:
		parent.movement.y += parent.grv/GlobalFunctions.div_by_delta(delta)
		parent.horizontalLockTimer = 1
	#grounded movement
	elif parent.ground:
		parent.movement.x = 10*60
		#jumping
		if parent.any_action_pressed():
			parent.animator.play("surfing")
			parent.animator.advance(0)
			parent.movement.y = -5*60
			parent.sfx[0].play()
			parent.airControl = false
			parent.cameraDragLerp = 1
			parent.disconect_from_floor()
	#bonk
	#parent.horizontalSensor.force_raycast_update()
	#if parent.horizontalSensor.is_colliding():
		#print("bonked")
		#parent.sfx[29].stop()
		#parent.sfx[6].play()
		#parent.movement.x = -sign(parent.movement.x)*2*60
		#parent.movement.y = -4*60
		#parent.z_index = 0
		#parent.set_state(parent.STATES.HIT)
		
