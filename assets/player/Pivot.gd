extends Position2D

onready var trail = $Trail

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		swipe()

func swipe():
	look_at(get_global_mouse_position())
	trail.play_swipe()
