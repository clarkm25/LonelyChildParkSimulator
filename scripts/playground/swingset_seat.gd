extends SittableRigidbody

@onready var qte = $"../QTE/"
var qte_active := false
var direction := 0

var z_dir = -1
var can_flip := true

var bonking_head := false
func _ready():
	activity_timer_name = "SwingTimer"
	super()
	
func _toggle_sit(state : bool):
	super(state)
	if state == true:
		player.height_reached.connect(peaked, CONNECT_ONE_SHOT)
		if !qte.playing:
			qte.play()
			bonking_head = false
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
		
		if $"../QTE/FlipChecker".is_colliding():
			player.height_reached.disconnect(peaked)
			bonking_head = true
			
			_toggle_sit(false)
			
func _custom_exit_behavior():
	# set player position and velocity to that of the swings so you fly off
	player.global_position = global_position
	
	if !bonking_head:
		player.rotation.x = 0
		player.rotation.z = 0
	
	player.velocity = Vector3(0, linear_velocity.y, linear_velocity.z)
	player.thrown = true
	
	if bonking_head:
		entered = false
		player.sliding = true
		player.bonkhead = true
		player.get_node("AnimationPlayer").play("swing_fall")
		
		
	player.move_and_slide()


func _on_qte_end(points: Variant) -> void:
	Engine.time_scale = 1
	player.happiness += points / 30
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
	
func peaked(height : float):
	var height_modifier = 3
	var score = round(height * height_modifier)
	player.happiness += score
	
	var hud = get_tree().get_first_node_in_group("hud")
	if score > 5:
		hud.addUpdate("      ",""," whoaaaa niece higt!",Color(1,1,0,1))
	else:
		hud.addUpdate("      ",""," are time!!",Color(0,1,0,1))
