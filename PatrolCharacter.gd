class_name PatrolCharacter2D
extends Character2D

signal path_requested(destination)

export(NodePath) var waypoint_cluster_path
var waypoint_cluser : Line2D

var path : PoolVector2Array setget set_path

func _ready():
	add_to_group("Patrol")
	
	if waypoint_cluster_path:
			waypoint_cluser = get_node(waypoint_cluster_path)

func next_vector() -> Vector2:
	if path.size() > 1:
		var dist = position.distance_to(path[1])
		if dist > 12:
			return (path[1] - position) / dist
		else:
			path.remove(0)
			return next_vector()
	
	return Vector2.ZERO

func set_path(new : PoolVector2Array):
	path = new

func rand_waypoint() -> Vector2:
	if waypoint_cluser:
		return waypoint_cluser.rand_point()
	return position

func request_path(destination : Vector2 = rand_waypoint()):
	emit_signal("path_requested", destination)
