extends Node3D

@onready var quicktime_circle = preload("res://scenes/components/quicktime_circle.tscn")
var playing := false
var circle
signal end(points)

func play():
	if !playing:
		playing = true
		circle = quicktime_circle.instantiate()
		add_child(circle)
		Engine.time_scale = 1
		
func stop():
	if playing:
		playing = false
		circle.queue_free()
		
		
	
