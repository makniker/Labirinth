extends TileMap

enum {DARK_TILE = 0, TRANSPARENT_TILE = 1}

func set_cell_visible(cell: Vector2, is_visible: bool):
	if is_visible:
		set_cellv(cell, TRANSPARENT_TILE)
	else:
		set_cellv(cell, DARK_TILE)

func set_all_set_visible(is_visible: bool):
		for cell in get_used_cells():
			set_cell_visible(cell, is_visible)

func update_shadows(arr: Array):
	for cell in arr:
		set_cell_visible(cell, true)
