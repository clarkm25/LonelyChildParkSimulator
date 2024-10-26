extends SittableRigidbody

@onready var qte = $"../QTE/"
var qte_active := false
var direction := 0

var z_dir = -1
var can_flip := true

func _ready():
	super()
	player.height_reached.connect(peaked)

func _toggle_sit(state : bool):
	super(state)
	if state == true and !qte.playing:
		qte.play()
	if state == false:
		qte.stop()

func _physics_process(delta):
	if entered:
		var raycast_collision = $"../QTE/CenterChecker".get_collider()
		if raycast_collision:
			if linear_velocity.z > 0:
				direction = -1
			elif linear_velocity.z < 0:
				direction = 1
			elif linear_velocity.z == 0:
				direction = 0
			can_flip = true
			
		if _is_velocity_direction_flipped() and !qte.playing:
			qte.play()
			
func _custom_exit_behavior():
	# set player position and velocity to that of the swings so you fly off
	player.global_position = global_position
	player.happiness +=20
	
	player.rotation.x = 0
	player.rotation.z = 0
	
	player.velocity = Vector3(0, linear_velocity.y, linear_velocity.z)
	player.thrown = true
	
	player.anim_player.play("flip")
	player.move_and_slide()


func _on_qte_end(points: Variant) -> void:
	Engine.time_scale = 1
	push(z_dir, points/3)
	
func _is_velocity_direction_flipped() -> bool:
	# checks if current direction matches stashed direction; if not, set direction to opposite
	# and return true for direction being flipped
	if can_flip:
		if angular_velocity.x < 0 and z_dir != 1:
			z_dir = 1
			can_flip = false
			return true
		if angular_velocity.x > 0 and z_dir != -1:
			z_dir = -1
			can_flip = true
			return true
	return false
	
func push(direction, score):
	var forward = transform.basis.z.normalized()
	apply_central_impulse(forward * direction * score)
	
func peaked(height):
	#TODO: add harry's function for happiness adding
	pass
