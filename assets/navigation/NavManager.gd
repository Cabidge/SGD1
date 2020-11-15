extends YSort

export(NodePath) var tile_map_path

var entities = []

onready var nav_gen = $NavGen

func _ready():
	nav_gen.generate(get_node(tile_map_path))
	
	for child in get_children():
		if child is PatrolCharacter2D:
			entities.append(child)
