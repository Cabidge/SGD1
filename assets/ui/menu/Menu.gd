extends Sprite

func _on_Timer_timeout():
	if randf() < 0.2:
		blink()
	else:
		twinkle()

func blink():
	frame = 1
	yield(get_tree().create_timer(0.13), "timeout")
	frame = 2
	yield(get_tree().create_timer(0.15), "timeout")
	frame = 1
	yield(get_tree().create_timer(0.15), "timeout")
	frame = 0

func twinkle():
	frame = 3 + randi() % 7
	yield(get_tree().create_timer(0.4), "timeout")
	frame = 0


func stop():
	visible = false
	$Timer.stop()
