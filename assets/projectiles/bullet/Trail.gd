extends Node

const LENGTH = 4

onready var bullet = get_parent()
onready var line = $Line2D

func _physics_process(delta):
	line.add_point(bullet.global_position)
	while line.get_point_count() > LENGTH:
		line.remove_point(0)
