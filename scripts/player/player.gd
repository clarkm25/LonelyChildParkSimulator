extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SLIDEFRICTION = 5.0
@export var mouse_sens := 0.002
@export var happiness := 50

@onready var hud= $%hud
@onready var camera = $Smoothing/Camera3D
@onready var smoothing = $Smoothing

signal height_reached(height)
var left_cam_limit = 180
var right_cam_limit = 180
var thrown := false
var falling := false
@export var sliding := false
@export var movecam := true
@export var bonkhead := false
var sitting : bool = false

func _ready():
	# locks mouse to window
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hud.happiness = happiness
	$AttentionTimer.start(10)

	
func _physics_process(delta):
	if sitting:
		$AttentionTimer.stop()
		hadfun()
		return
	
	if $AttentionTimer.is_stopped() && !sitting:
		if !sliding:
			$AttentionTimer.start(2)
		
	# Add the gravity.
	if is_on_floor():
		thrown = false
		falling = false
		
		if sliding:
			velocity = velocity.move_toward(Vector3(0, velocity.y, 0), SLIDEFRICTION * delta)
	else:
		velocity += get_gravity() * delta
		
	if sliding:
		if velocity.x == 0 and velocity.z == 0 and !movecam:
			$AnimationPlayer.queue("get_up")
			movecam = true
			happiness -= 10
			if bonkhead:
				hud.addUpdate("      ",""," OUCHHH MY HECK*NG HEAD :(((( i shud try to jump off erlier!",Color(1,0,0,1))
				bonkhead = false
			else:
				hud.addUpdate("      ",""," owww i skined my knee :( i shud try to jump off erlier!",Color(1,0,0,1))

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !sliding:
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.Z
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	hud.updateHud()
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if !thrown and !sliding:
		if direction:
			$StairstepCollider.position = Vector3(0.34*input_dir.x, -0.457, 0.34*input_dir.y)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	if thrown:
		if velocity.y < 0 and !falling:
			falling = true
			height_reached.emit(global_position.y)
			print(global_position.y)
	
	hadfun()
			
func hadfun():
	if happiness != hud.happiness:
		if happiness > hud.happiness:
			if happiness > 100:
				hud.addUpdate(happiness-hud.happiness,"+"," im so fr*cking hapy rite now",Color(0,1,0,1))
				happiness = 100
			else:
				hud.addUpdate(happiness-hud.happiness,"+","",Color(0,1,0,1))
			hud.happiness = happiness
			hud.updateHud()
		elif happiness < hud.happiness:
			if happiness < 0:
				hud.addUpdate(hud.happiness-happiness,"-"," You are the saddest child ever.",Color(1,0,0,1))
				happiness = 0
			else:
				hud.addUpdate(hud.happiness-happiness,"-","",Color(1,0,0,1))
			hud.happiness = happiness
			hud.updateHud()
			
			


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and movecam:
		rotate_y(-event.relative.x * mouse_sens)
		rotation.y = clampf(rotation.y, -deg_to_rad(left_cam_limit), deg_to_rad(right_cam_limit))

		camera.rotate_x(-event.relative.y * mouse_sens)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_attention_timer_timeout() -> void:
	happiness -= 1
