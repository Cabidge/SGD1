extends Camera2D

onready var tween = $Tween

func zoom_in(scalar : float):
	tween.remove_all()
	tween.interpolate_property(self,"zoom",null,Vector2.ONE * scalar,\
			1,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	tween.start()
