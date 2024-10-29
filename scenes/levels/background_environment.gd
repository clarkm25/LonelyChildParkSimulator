extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Environment_Noises/AmbianceNoiseTimer.wait_time = randf()*30 + 15
	$Environment_Noises/AmbianceNoiseTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move the location of the environment audio players to be...
	# ontop of the player so they can't walk away from environment sounds
	if $"../Player" == null:
		return
	$Environment_Noises.position = $"../Player".position


func _on_timer_timeout() -> void:
	$Environment_Noises/AudioStreamPlayer3D_Ambiance.play()
	$Environment_Noises/AmbianceNoiseTimer.wait_time = randf()*30 + 15
	$Environment_Noises/AmbianceNoiseTimer.start()
