extends SittableRigidbody

var tipped := false
var hit_ground := false
func _toggle_sit(state : bool):
	super(state)
	if state and !tipped:
		$"../HingeJoint3D".set_flag(HingeJoint3D.FLAG_ENABLE_MOTOR, true)
		tipped = true
	if !state and tipped:
		$"../HingeJoint3D".set_flag(HingeJoint3D.FLAG_ENABLE_MOTOR, false)
		tipped = false
		hit_ground = false

		
func _physics_process(delta):
	if rotation_degrees.z <= -14.0 and !hit_ground and entered:
		var hud = get_tree().get_first_node_in_group("hud")
		player.happiness -= 10
		hud.addUpdate("      ",""," no 1 2 play wif :(",Color(1,0,0,1))
		hit_ground = true
