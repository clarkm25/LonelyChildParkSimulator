extends SittableRigidbody

@onready var qte = $"../QTE/"
var qte_active := false
var direction := 0

var previous_z_value := 0
func _ready():
	super()

func _physics_process(delta):
	if entered:
		#if linear_velocity.z == 0:
			#qte.play()
		#elif (linear_velocity.z*previous_z_value < 0) and !qte.playing:
			#qte.play()
		
		if linear_velocity.is_zero_approx() and !qte.playing:
			qte.play()
			
		var raycast_collision = $"../QTE/CenterChecker".get_collider()
		if raycast_collision:
			if linear_velocity.z > 0:
				direction = -1
			elif linear_velocity.z < 0:
				direction = 1
			elif linear_velocity.z == 0:
				direction = 0
			
			print(direction)
		previous_z_value = linear_velocity.z
			

func _custom_exit_behavior():
	# set player position and velocity to that of the swings so you fly off
	player.global_position = global_position
	player.rotation.x = 0
	player.rotation.z = 0
	
	player.velocity = Vector3(0, linear_velocity.y, linear_velocity.z)
	player.thrown = true
	
	player.anim_player.play("flip")
	player.move_and_slide()


func _on_qte_end(points: Variant) -> void:
	Engine.time_scale = 1
	if direction == 0:
		direction = -1
	apply_central_impulse(Vector3(0,0,direction*30))
