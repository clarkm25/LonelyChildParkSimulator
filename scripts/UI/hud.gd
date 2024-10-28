extends Control



@onready var happinessBarValue = $HSlider
@onready var updates = $hudUpdate
@onready var overlay = $overlay

var happiness
var item = preload("res://scenes/UI/hud_item.tscn")

func _ready():
	happinessBarValue.value = happiness
	
func updateHud():
	happinessBarValue.value = happiness
	
func addUpdate(qty,text1,text2,color):
	var lab = item.instantiate()
	lab.text = ""+text1+str(qty)+text2
	lab.set_modulate(color)
	updates.add_child(lab)
