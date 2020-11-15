extends TileMap

var block_scene = load("res://assets/ProjectileBlock.tscn")

func _ready():
	for cell in get_used_cells():
		var pos = map_to_world(cell) + Vector2.RIGHT * 12
		var block = block_scene.instance()
		block.position = pos
		add_child(block)
