extends Area2D

signal selected

func can_stab() -> bool:
	return true

func stall():
	emit_signal("selected")
