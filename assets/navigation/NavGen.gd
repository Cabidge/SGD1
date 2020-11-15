extends Navigation2D

onready var nav_map = $TileMap

func generate(wall_map : TileMap, floor_map : TileMap):
	for floor_cell in floor_map.get_used_cells():
		if wall_map.get_cell(floor_cell.x,floor_cell.y) == -1:
			nav_map.set_cell(floor_cell.x,floor_cell.y,1)
	
	nav_map.update_bitmask_region()
