class_name PatrolCharacter2D
extends Character2D

signal path_completed

var path : PoolVector2Array
var vec : Vector2 = Vector2.ZERO

func _ready():
	add_to_group("Patrol")

func follow_path(speed : float) -> bool:
	if path.size() > 0:
		print(path[0])
		var dist = position.distance_to(path[0])
		if dist > 12:
			var Vec = (path[0] - position) / dist
			vec = vec.linear_interpolate(Vec,0.05).normalized()
			lerp_vel(vec,speed,0.2)
			handle_movement()
		else:
			path.remove(0)
	else:
		position = position.round()
		vec = Vector2.ZERO
#		lerp_vel(Vector2.ZERO,0)
#		handle_movement()
		emit_signal("path_completed")
		return false
	return true
