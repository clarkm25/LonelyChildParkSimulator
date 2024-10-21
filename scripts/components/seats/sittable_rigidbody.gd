@icon("res://assets/materials/seat.svg")
class_name SittableRigidbody
extends RigidBody3D

## This seat's camera
@export var main_camera : Camera3D

## The MeshInstance3D that will be highlighted when the player gets
## close to the seat
@export var highlight_target : MeshInstance3D

@export var outline_thickness := 0.00025
var glow_shader = preload("res://assets/materials/outline3D.gdshader")

var enterable := false
var entered := false

var player : CharacterBody3D

var debug := false
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		entered = true

func _on_hover_detector_area_entered(area):
	highlight_target.set_instance_shader_parameter("thickness", outline_thickness)
	enterable = true

func _on_hover_detector_area_exited(area):
	highlight_target.set_instance_shader_parameter("thickness", 0)
	enterable = false
	
func _input(event):
	if event.is_action_pressed("interact"):
		if enterable:
			player.hide()
			player.process_mode = Node.PROCESS_MODE_DISABLED
			main_camera.current = true
			enterable = false
			entered = true
		elif entered:
			player.show()
			player.process_mode = Node.PROCESS_MODE_INHERIT
	#		player.look_at(global_position + linear_velocity.normalized())

			main_camera.current = false
			enterable = true
			entered = false
