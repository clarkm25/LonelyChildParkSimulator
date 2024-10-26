extends Control

signal qte_passed
signal qte_failed

## The object to look for when initializing QTE based on the position
@export var movement_object : Area3D
## The area that movement_object passes through to start the QTE
@export var start_tracker_area : Area3D
## The area that movement_object passes through to end the QTE
@export var end_tracker_area : Area3D

@export var action_to_press : InputEventAction

## how slowed / sped up time is during the QTE
@export var timescale := 1.0

@onready var key_popup = $KeyPopup

var active := false
var passed := false

func _ready():
	end_tracker_area.body_entered.connect(end_qte)

func _physics_process(delta: float) -> void:
	if !active:
		if !passed:
			var bodies = start_tracker_area.get_overlapping_bodies()
			if !bodies.is_empty():
				start_qte(bodies[0])
				return

func start_qte(body):
	if body.linear_velocity.z <= 0:
		# set active = true, apply timescale, tell input function to watch for requested key
		active = true
		passed = false
		Engine.time_scale = timescale
		key_popup.show()

func end_qte(body):
	if active:
		active = false
		Engine.time_scale = 1
		key_popup.hide()
		
		if passed:
			print("passed")
			passed = true
			qte_passed.emit()
		else:
			print("failed")
			qte_failed.emit()

#func _input(event):
	#if event.is_action_pressed("quicktime"):
		#if active:
			#passed = true
			#end_qte(end_tracker_area)
