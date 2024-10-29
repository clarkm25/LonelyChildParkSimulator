extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("Drive")
	$AudioStreamPlayer3D.play()


func _on_bad_ending_delay_sound_timer_timeout() -> void:
	$"AudioStreamPlayer3D_BadEnding".play()
