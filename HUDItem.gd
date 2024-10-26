extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self,"position",Vector2(0,-60),2)
	tween.parallel().tween_property(self,"modulate:a",0,2)
	tween.tween_callback(queue_free)
