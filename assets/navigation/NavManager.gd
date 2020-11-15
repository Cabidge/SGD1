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
	if event.is_action_pressed("attack"):
		entities[0].path = generate_path(entities[0], get_global_mouse_position())

func generate_path(entity : PatrolCharacter2D, destination : Vector2):
	var path = nav_gen.get_simple_path(entity.position,destination)
	return path
