extends RigidBody3D

func _physics_process(delta):
	if Input.is_action_pressed("move_forward"):
		var force = Vector3(5, 0, 0)
		apply_central_force(force)
	if Input.is_action_pressed("move_backward"):
		var force = Vector3(-5, 0, 0)
		apply_central_force(force)
	
