extends AudioStreamPlayer2D

export var looping = false

func loop():
	play()
	looping = true

func stop():
	looping = false
	.stop()

func _on_AudioAlert2D_finished():
	if looping:
		play()
