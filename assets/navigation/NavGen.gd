extends Navigation2D

onready var nav_map = $TileMap

func generate(tile_map : TileMap):
	for cell in tile_map.get_used_cells():
		nav_map.set_cell(cell.x,cell.y,0)
