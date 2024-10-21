extends SittableRigidbody

@onready var qte = $"../QTE/Quicktime"
func _ready():
	super()

func _physics_process(delta):
	if entered:
		if Input.is_action_just_pressed("move_forward"):
			apply_central_impulse(Vector3(0, 0, -30))
		if Input.is_action_just_pressed("move_back"):
			apply_central_impulse(Vector3(0, 0, 30))

func _custom_exit_behavior():
	# set player position and velocity to that of the swings so you fly off
	player.global_position = global_position
	player.rotation.x = 0
	player.rotation.z = 0
	
	player.velocity = Vector3(0, linear_velocity.y, linear_velocity.z)
	player.thrown = true
	
	player.move_and_slide()
