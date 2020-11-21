tool
extends AnimatedSprite

export var is_open = false setget set_is_open

func set_is_open(new):
	is_open = new
	frame = int(is_open) * 10

func open():
	is_open = true
	play("Open")

func close():
	is_open = false
	play("Open",true)
