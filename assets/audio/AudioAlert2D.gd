tool
extends AudioStreamPlayer2D

export var alert_level = 0
export var radius = 0.0 setget set_radius, get_radius
export var looping = false

onready var area = $Area2D

func set_radius(new):
	$Area2D/CollisionShape2D.shape.radius = new

func get_radius():
	return $Area2D/CollisionShape2D.shape.radius


func play(from_positon : float = 0.0):
	.play(from_positon)
	if radius > 0:
		for alert_receiver in area.get_overlapping_areas():
			alert_receiver.alert(alert_level, global_position)

func loop():
	play()
	looping = true

func stop():
	looping = false
	.stop()

func _on_AudioAlert2D_finished():
	if looping:
		play()
