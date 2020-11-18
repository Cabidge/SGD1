extends "res://assets/backstab/StabRange.gd"

const BACKSTAB_ANGLE = deg2rad(65)

func can_stab(player : Character2D) -> bool:
	var player_vec = (player.position - get_parent().position)
	var back_normal = Vector2.LEFT.rotated(get_parent().angle)
	var angle = player_vec.angle_to(back_normal)
	return abs(angle) <= BACKSTAB_ANGLE
