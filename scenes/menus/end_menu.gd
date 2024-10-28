extends Control


# Called when the node enters the scene tree for the first time.
func _on_try_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/Rule.tscn")


func _on_end_game_pressed() -> void:
	get_tree().quit()
