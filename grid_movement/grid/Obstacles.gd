extends TileMap

var obstacles = Array()

func update_obst():
	for cell in get_used_cells():
		obstacles.insert(obstacles.bsearch(cell), cell)

func is_wall(cell: Vector2) -> bool:
	return get_cellv(cell) != -1 && get_cellv(cell) != 1

func add_obst_tile(cell: Vector2):
	set_cellv(cell, 1)	

func is_obst_for_light(cell: Vector2) -> bool:
	var t = obstacles.bsearch(cell)
	if t != len(obstacles):
		return obstacles[t] == cell
	else:
		return false

func calculate_fow(pos: Vector2, distance: int) -> Array:
	var fow = Array()
	var x0 = pos.x
	var y0 = pos.y
	var obsts_ctg:PoolRealArray = PoolRealArray()
	var obsts_tg:PoolRealArray = PoolRealArray()
	var quarts:PoolByteArray = PoolByteArray()
	
	var tg:float
	var ctg:float
	
	var obst_ctg:float
	var obst_tg:float
	
	var is_visible1:bool
	var is_visible2:bool
	var is_visible3:bool
	var is_visible4:bool
	
	var is_obst1:bool
	var is_obst2:bool
	var is_obst3:bool
	var is_obst4:bool
	
	for y in range(distance+1):
		for x in range(distance -y + 1):
			tg = float(y)/x if x != 0 else INF
			ctg = float(x)/y if y != 0 else INF
			
			obst_ctg = (x-0.5)/(y+0.5)
			obst_tg = (y-0.5)/(x+0.5)
			
			is_obst1 = false
			is_obst2 = false
			is_obst3 = false
			is_obst4 = false

			if is_obst_for_light(Vector2(x0+x, y0+y)):
				is_obst1 = true
			
			if is_obst_for_light(Vector2(x0-x, y0-y)):
				is_obst2 = true
			
			if is_obst_for_light(Vector2(x0+x, y0-y)):
				is_obst3 = true
			
			if is_obst_for_light(Vector2(x0-x, y0+y)):
				is_obst4 = true
		
			is_visible1 = true
			is_visible2 = true
			is_visible3 = true
			is_visible4 = true
			
			for i in range(len(obsts_ctg)):
				if tg > obsts_tg[i] and ctg > obsts_ctg[i]:
					match quarts[i]:
						1:
							is_visible1 = false
							if obst_tg > obsts_tg[i] and obst_ctg > obsts_ctg[i]:
								is_obst1 = false
						2:
							is_visible2 = false
							if obst_tg > obsts_tg[i] and obst_ctg > obsts_ctg[i]:
								is_obst2 = false
						3:
							is_visible3 = false
							if obst_tg > obsts_tg[i] and obst_ctg > obsts_ctg[i]:
								is_obst3 = false
						4:
							is_visible4 = false
							if obst_tg > obsts_tg[i] and obst_ctg > obsts_ctg[i]:
								is_obst4 = false
			
			if is_obst1:
				obsts_tg.append(obst_tg)
				obsts_ctg.append(obst_ctg)
				quarts.append(1)
				
			if is_obst2:
				obsts_tg.append(obst_tg)
				obsts_ctg.append(obst_ctg)
				quarts.append(2)
				
			if is_obst3:
				obsts_tg.append(obst_tg)
				obsts_ctg.append(obst_ctg)
				quarts.append(3)
				
			if is_obst4:
				obsts_tg.append(obst_tg)
				obsts_ctg.append(obst_ctg)
				quarts.append(4)
					
			if is_visible1:
				fow.append(Vector2(x+x0, y+y0))
				
				
			if is_visible2:
				if x != 0:
					fow.append(Vector2(-x+x0, -y+y0))
					
					
			if is_visible3:
				if y != 0:
					fow.append(Vector2(x+x0, -y+y0))
					
				
			if is_visible4:
				if x != 0 and y != 0:
					fow.append(Vector2(-x+x0, y+y0))
					
	return fow
