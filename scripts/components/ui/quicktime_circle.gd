extends Control

@export var score := 0
@export var speed := 1.5
@onready var score_label : Label = $num

signal qte_start
signal qte_end

func _input(event):
	if event.is_action_pressed("quicktime"):
		$Control.hide()
		$AnimationPlayer.pause()
		get_parent().end.emit(score)
		get_parent().stop()
		
		if score == 100:
			score_label.text = "perfect!\n+100"
		else:
			score_label.text = "+" + str(score)
		
		if score > 60:
			score_label.label_settings.font_color = Color("16bb77")
		else:
			score_label.label_settings.font_color = Color.WHITE_SMOKE
		score_label.show()
		$Timer.start()

func _on_timer_timeout():
	queue_free()
