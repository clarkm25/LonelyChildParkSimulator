extends SittableRigidbody
var amount_spins := 0.0

@onready var qte = $"../QTE"
func _physics_process(delta):
	if entered:
		var raycast_collision = $"../QTE/CenterChecker".get_collider()
		if raycast_collision:
			if amount_spins >= (angular_velocity.y):
				qte.play()
				amount_spins = 0.0
			else:
				amount_spins = amount_spins + 1.0
				
## Set the sitting state of the user.
## Reparents the player to the player_seated_location node
## runs _custom_exit_behavior if override_exit_behavior is set to true
func _toggle_sit(state : bool):
	super(state)
	if state == true and !qte.playing:
		qte.play()
	if state == false:
		qte.stop()

func _custom_exit_behavior():
	# set player position and velocity to that of the carousel so you fly off
	player.rotation.x = 0
	player.rotation.z = 0

	var throw_direction = global_position.direction_to(player.global_position)
	player.velocity = throw_direction * angular_velocity.length()
	player.thrown = true
	
	player.move_and_slide()


func _on_qte_end(points):
	apply_torque_impulse(Vector3(0, 0.00005 * points, 0))
