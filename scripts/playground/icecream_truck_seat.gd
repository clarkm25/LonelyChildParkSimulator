extends SittableRigidbody

func _physics_process(delta):
	if entered:
		if Input.is_action_just_pressed("ui_accept"):
			apply_torque_impulse(Vector3(0, 0.0025, 0))
