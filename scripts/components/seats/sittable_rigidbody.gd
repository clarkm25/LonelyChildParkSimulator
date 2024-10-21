@icon("res://assets/materials/seat.svg")
class_name SittableRigidbody
extends RigidBody3D

## This seat's player location object, a Node3D
## when getting in this seat the player will be reparented to this node.
## this should usually be a child of smoothing
@export var player_seated_location : Node3D
var original_player_pos := Vector3.ZERO
@export var override_exit_behavior := false

## Specifies if the user can freely move their mouse when sitting on this seat
## NOTE: this is not implemented yet as a toggle as of 10/21/24, default is yes -n8
@export var free_look : bool

@export_category("Glowing Selection")
## The Area3D denoting where the player's raycast can collide with this
@export var hover_detector : Area3D

## The MeshInstance3D that will be highlighted when the player gets
## close to the seat
@export var highlight_target : MeshInstance3D
@export var glow_outline_thickness := 0.00025

var glow_shader = preload("res://assets/materials/outline3D.gdshader")

var enterable := false
var entered := false

var player : CharacterBody3D

var player_cam_pos : Vector3

var debug := false

var QTE : Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		entered = true
		
	hover_detector.connect("area_entered", _on_hover_detector_area_entered)
	hover_detector.connect("area_exited", _on_hover_detector_area_exited)
	
	QTE = get_node_or_null("QTE")
	#highlight_target.material_overlay = glow_shader

func _on_hover_detector_area_entered(area):
	if !entered:
		highlight_target.set_instance_shader_parameter("thickness", glow_outline_thickness)
		enterable = true

func _on_hover_detector_area_exited(area):
	highlight_target.set_instance_shader_parameter("thickness", 0)
	enterable = false
	
func _input(event):
	if event.is_action_pressed("interact"):
		if enterable:
			highlight_target.set_instance_shader_parameter("thickness", 0)
			enterable = false
			entered = true
			_toggle_sit(true)
		elif entered:
			entered = false
			_toggle_sit(false)
			

## Set the sitting state of the user.
## Reparents the player to the player_seated_location node
## runs _custom_exit_behavior if override_exit_behavior is set to true
func _toggle_sit(state : bool):
	player.sitting = state
	if state == true:
		original_player_pos = player.position
		
		player.reparent(player_seated_location)
		
		# weird fix for frame smoothing not working when stacked
		player.camera.reparent(player)
		player.rotation.x = 0
		player.rotation.y = 0
		player.rotation.z = 0
		
		player.left_cam_limit = 70
		player.right_cam_limit = 70
		player.camera.rotation = Vector3.ZERO
		player.position = Vector3.ZERO
	elif state == false:
		player.camera.reparent(player.smoothing)
		player.camera.rotation = Vector3.ZERO
		player.camera.position.x = 0
		player.camera.position.z = 0
		
		player.left_cam_limit = 180
		player.right_cam_limit = 180
		player.reparent(get_tree().root)
		
		if !override_exit_behavior:
			player.position = original_player_pos
		else:
			_custom_exit_behavior()

## OVERRIDE IN CHILDREN: allows you to specify custom behavior for what happens
## on player leaving this seat. I.e., swings give the player their velocity 
## and position on exit
func _custom_exit_behavior():
	pass
