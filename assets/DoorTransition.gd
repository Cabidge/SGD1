extends Control

export var progress := 0.0 setget set_progress

var width = ProjectSettings.get_setting("display/window/size/width")

onready var left = $Left
onready var right = $Right

onready var tween = $Tween

func set_progress(new):
	progress = new
	
	var length = lerp(0,width/2,progress)
	left.rect_size.x = length
	right.rect_size.x = length
	right.rect_position.x = width - length


func close():
	tween.interpolate_property(self,"progress",0,1,0.6,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func open():
	tween.interpolate_property(self,"progress",1,0,0.6,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()
