extends Position2D

onready var light = $Light2D
onready var tween = $Tween

func tween_light(color : Color):
	tween.remove_all()
	tween.interpolate_property(light,"color",null,color,0.5,Tween.TRANS_QUAD)
	tween.start()
