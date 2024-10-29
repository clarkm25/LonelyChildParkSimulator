extends Node3D

@onready var anim_player = $AnimationPlayer
@onready var player = $Smoothing/Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Player.global_position = $Node3D.global_position
	$Player.axis_lock_linear_x = false
	$Player.axis_lock_linear_y = false
	$Player.axis_lock_linear_z = false
	$Player.axis_lock_angular_x = false
	$Player.axis_lock_angular_y = false
	$Player.axis_lock_angular_z = false
	$Player.movecam = true	
	$Player.reparent(get_tree().current_scene)
