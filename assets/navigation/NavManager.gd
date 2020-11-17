extends YSort

export(NodePath) var wall_path
export(NodePath) var floor_path

var entities = []

onready var nav_gen = $NavGen

func _ready():
	nav_gen.generate(get_node(wall_path),get_node(floor_path))
	
	for child in get_children():
		if child is PatrolCharacter2D:
			entities.append(child)
			child.connect("path_requested", self, "_on_Entity_path_requested", [child])
			child.path = generate_path(child, child.rand_waypoint())

func _on_Entity_path_requested(destination : Vector2, entity : PatrolCharacter2D):
	entity.path = generate_path(entity, destination)

func generate_path(entity : PatrolCharacter2D, destination : Vector2):
	destination = snap_to_tile(destination)
	var from = snap_to_tile(entity.position)
	
	var path = nav_gen.get_simple_path(from,destination,true)
	return path

func snap_to_tile(pos : Vector2):
	pos = (pos / Global.TILE).floor() * Global.TILE
	pos += Vector2.ONE * Global.TILE/2
	return pos
