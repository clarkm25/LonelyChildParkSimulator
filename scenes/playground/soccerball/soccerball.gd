extends Node3D

var interactable = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_rigid_body_3d_body_entered(body: Node) -> void:
	if body is CharacterBody3D and interactable:
		interactable = false
		get_tree().get_first_node_in_group("player").happiness += 5
		$Timer.start()
		

func _on_timer_timeout() -> void:
	interactable = true
	$Timer.stop()
	
	
