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

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var entity = entities[randi() % entities.size()]
		entity.path = generate_path(entity, get_global_mouse_position())

func generate_path(entity : PatrolCharacter2D, destination : Vector2):
	destination = snap_to_tile(destination)
	var from = snap_to_tile(entity.position)
	
	var path = nav_gen.get_simple_path(from,destination,true)
	return path

func snap_to_tile(pos : Vector2):
	pos = (pos / Global.TILE).floor() * Global.TILE
	pos += Vector2.ONE * Global.TILE/2
	return pos
