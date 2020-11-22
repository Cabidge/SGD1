extends Node2D

var sprite : AnimatedSprite

onready var step = $Step

func start():
	step.play()
	var err = sprite.connect("frame_changed",self,"_on_sprite_frame_changed")
	assert(err == OK)

func stop():
	if sprite.is_connected("frame_changed",self,"_on_sprite_frame_changed"):
		sprite.disconnect("frame_changed",self,"_on_sprite_frame_changed")

func _on_sprite_frame_changed():
	if [0,5].has(sprite.frame):
		step.play()
