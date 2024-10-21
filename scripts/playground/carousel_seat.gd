extends SittableRigidbody

func _physics_process(delta):
	if entered:
		if Input.is_action_just_pressed("ui_accept"):
			apply_torque_impulse(Vector3(0, 0.0025, 0))

func _custom_exit_behavior():
	# set player position and velocity to that of the carousel so you fly off
	player.rotation.x = 0
	player.rotation.z = 0

	var throw_direction = global_position.direction_to(player.global_position)
	player.velocity = throw_direction * angular_velocity.length()
	player.thrown = true
	
	player.move_and_slide()
