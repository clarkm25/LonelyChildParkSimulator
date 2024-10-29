extends SittableRigidbody
var amount_spins := 0.0
var skinned_knee := false
@onready var qte = $"../QTE"

func _ready():
	activity_timer_name = "CarouselTimer"
	super()
func _physics_process(delta):
	if entered:
		var raycast_collision = $"../QTE/CenterChecker".get_collider()
		if raycast_collision:
			if amount_spins >= (angular_velocity.y):
				qte.play()
				amount_spins = 0.0
			else:
				amount_spins = amount_spins + 1.0
		print(angular_velocity)
		if angular_velocity.y > 12.25:
			skinned_knee = true
			entered = false
			_toggle_sit(false)
	
## Set the sitting state of the user.
## Reparents the player to the player_seated_location node
## runs _custom_exit_behavior if override_exit_behavior is set to true
func _toggle_sit(state : bool):
	super(state)
	if state == true and !qte.playing:
		qte.play()
		skinned_knee = false
	if state == false:
		qte.stop()

func _custom_exit_behavior():
	# set player position and velocity to that of the carousel so you fly off
	player.rotation.x = 0
	player.rotation.z = 0

	var throw_direction = global_position.direction_to(player.global_position).normalized()
	var throwpower = throw_direction * angular_velocity.length()
	if skinned_knee:
		throwpower.y = 0.2
		player.sliding = true
		player.movecam = false
		player.get_node("AnimationPlayer").play("slide_off")

	player.velocity = throwpower
	player.thrown = true
	
	player.move_and_slide()


func _on_qte_end(points):
	apply_torque_impulse(Vector3(0, 0.00005 * points, 0))
	player.happiness += points / 50
