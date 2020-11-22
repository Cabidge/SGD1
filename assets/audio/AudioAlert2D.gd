extends AudioStreamPlayer2D

enum LEVELS {
	CALM,
	SUS_LOW,
	SUS_HIGH,
	ALERT_LOW,
	ALERT_HIGH
}

export(LEVELS) var alert_level := 0
export(LEVELS) var alert_threshold := 0
export var looping = false

var disabled = true

onready var area = $Area2D

func _ready():
	for child in get_children():
		if child is CollisionShape2D:
			remove_child(child)
			area.add_child(child)
			disabled = false


func play(from_positon : float = 0.0):
	.play(from_positon)
	if !disabled:
		for alert_receiver in area.get_overlapping_areas():
			alert_receiver.alert(alert_level, alert_threshold, global_position)

func loop():
	play()
	looping = true

func stop():
	looping = false
	.stop()

func _on_AudioAlert2D_finished():
	if looping:
		play()
