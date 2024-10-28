extends Control



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/Rule.tscn")

func _on_end_button_pressed() -> void:
	get_tree().quit()
