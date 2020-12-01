extends Sprite

onready var anim = $AnimationPlayer

func show_floor(num : int):
	frame = num
	anim.play("Show")
