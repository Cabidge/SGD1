extends Node2D

func disable():
	for light in get_children():
		light.enabled = false
