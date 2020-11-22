extends Area2D

signal alerted(level,threshold,location)

func alert(level : int, threshold : int, location : Vector2):
	emit_signal("alerted",level,threshold,location)
