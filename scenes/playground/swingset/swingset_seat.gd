extends SittableRigidbody

func _physics_process(delta):
	if entered:
		if Input.is_action_just_pressed("move_forward"):
			apply_central_impulse(Vector3(0, 0, -30))
		if Input.is_action_just_pressed("move_back"):
			apply_central_impulse(Vector3(0, 0, 30))

func _input(event):
	if event.is_action_pressed("interact"):
		if enterable:
			player.hide()
			player.process_mode = Node.PROCESS_MODE_DISABLED
			main_camera.current = true
			enterable = false
			entered = true
		elif entered:
			player.show()
			player.process_mode = Node.PROCESS_MODE_INHERIT
			
			# angular velocity equation
			var radius = global_position.distance_to($"../HingeJoint3D".global_position)
			
			# set player position and velocity to that of the swings so you fly off
			player.global_position = global_position
			
			player.rotation.y = $"..".rotation.y
			player.camera.rotation.x = rotation.x
		
			player.velocity += Vector3(0, linear_velocity.y, linear_velocity.z)
			player.thrown = true
			
			player.move_and_slide()
			
			main_camera.current = false
			enterable = true
			entered = false
