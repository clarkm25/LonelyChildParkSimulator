extends SittableRigidbody

var tipped := false

func _toggle_sit(state : bool):
	super(state)
	if state and !tipped:
		$"../HingeJoint3D".set_flag(HingeJoint3D.FLAG_ENABLE_MOTOR, true)
		tipped = true
