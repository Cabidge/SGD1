extends Position2D

onready var trail = $Trail

func swipe():
	look_at(get_global_mouse_position())
	trail.play_swipe()
