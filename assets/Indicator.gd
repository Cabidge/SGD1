extends Node2D

var enabled = false setget set_enabled

onready var anim_player = $AnimationPlayer

func set_enabled(new):
	if enabled != new:
		enabled = new
		if enabled:
			anim_player.play("Show")
		else:
			anim_player.play_backwards("Show")
