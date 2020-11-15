class_name PatrolCharacter2D
extends Character2D

signal path_completed

var path : PoolVector2Array setget set_path

func _ready():
	add_to_group("Patrol")

func follow_path(speed : float) -> bool:
	if path.size() > 0:
		var dist = position.distance_to(path[0])
		if dist > 12:
			var vec = (path[0] - position) / dist
			vec = vec.round().normalized()
			lerp_vel(vec,speed,0.2)
			handle_movement()
		else:
			path.remove(0)
	else:
		position = position.round()
		emit_signal("path_completed")
		return false
	return true

func set_path(new : PoolVector2Array):
	path = new
