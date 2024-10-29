extends SittableRigidbody

func _input(event):
	if event.is_action_pressed("interact"):
		if $"../AnimationPlayer".is_playing():
			return
		if enterable:
			highlight_target.set_instance_shader_parameter("thickness", 0.2)
			enterable = false
			entered = true
			_toggle_sit(true)
		elif entered:
			return

func _toggle_sit(state : bool):
	player.sitting = state
	if state == true:
		original_player_pos = player.position
		
		player.reparent(player_seated_location)
		
		# weird fix for frame smoothing not working when stacked
		player.camera.reparent(player)
		player.rotation.x = 0
		player.rotation.y = 0
		player.rotation.z = 0
		
		player.left_cam_limit = 70
		player.right_cam_limit = 70
		player.camera.rotation = Vector3.ZERO
		player.position = Vector3.ZERO
		
		$"../AnimationPlayer".play("Garage_Door_Retract")
		if player.happiness >= 70:
			$"../AnimationPlayer".queue("The_Good_Ending")
		else:
			$"../AnimationPlayer".queue("The_Bad_Ending")
			$"../BadEndingDelaySoundTimer".start()
	
	elif state == false:
		return

func close_game():
	get_tree().quit()
