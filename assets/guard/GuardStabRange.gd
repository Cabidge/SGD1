extends "res://assets/backstab/StabRange.gd"

const BACKSTAB_ANGLE = deg2rad(65)

onready var parent = get_parent()

func can_stab(player : Character2D) -> bool:
	if parent.state_machine.state == parent.state_machine.states.attack:
		return false
	
	var player_vec = (player.position - get_parent().position)
	var back_normal = Vector2.LEFT.rotated(parent.angle)
	var angle = player_vec.angle_to(back_normal)
	return abs(angle) <= BACKSTAB_ANGLE
