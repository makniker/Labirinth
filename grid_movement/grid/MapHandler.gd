extends Node

onready var fog = $Fog
onready var player = $Player
onready var grass = $Grass
onready var obst = $Obstacles

export(PackedScene) var light_source_scene = preload("res://grid_movement/pawns/LightSource.tscn")

var lights_sources = [Vector2(5, 5)]

func _ready():
	obst.update_obst()
	fog.set_all_set_visible(false)
	spawn_pawn(player, Vector2(3, 3))
	place_random_light_sources(6)
	place_light_sources(lights_sources)

func _process(_delta):
	update_shadows()

func place_random_light_sources(count: int):
	for _i in range(0, count):
		var inst = light_source_scene.instance()
		add_child(inst)
		var vec = Vector2(randi() % 30, randi() % 30)
		if !obst.is_wall(vec):
			spawn_pawn(inst, vec)
			obst.add_obst_tile(vec)
			
func place_light_sources(lights_sources_places: Array):
	for vec in lights_sources_places:
		var inst = light_source_scene.instance()
		add_child(inst)
		if !obst.is_wall(vec):
			spawn_pawn(inst, vec)
			obst.add_obst_tile(vec)

func spawn_pawn(pawn, pos):
	assert(obst.get_cellv(pos) == -1)
	pawn.spawn(pos)

func is_in_visible_line(pawn1: Pawn, pos: Vector2, light_range: int) -> bool:
	if pawn1.get_position() == pos:
		return true
	if is_in_radius(pawn1.get_position(), pos, light_range):
		var direction = pawn1.get_position().direction_to(pos)
		var vec2 = pawn1.get_position()
		while is_in_radius(pos, vec2, light_range):
			if obst.is_wall(vec2):
				return false
			vec2 += direction
		return true
	return false


func is_in_fow(pawn1: Pawn, visible_cells: Array):
	for cell in visible_cells:
		if is_in_visible_line(pawn1, cell, pawn1.light_range):
			return true
	return false
	

func is_in_radius(center: Vector2, point: Vector2, radius) -> bool:
	return abs(center.x - point.x) + abs(center.y - point.y) <= radius

func update_shadows():
	fog.set_all_set_visible(false)
	for child in get_children():
		if child is Pawn:
			var arr = obst.calculate_fow(child.get_position(), child.light_range)
			if is_in_fow(player, arr):
				update_shadow(obst.world_to_map(child.position), arr, child.light_range)
		
func request_move(pawn: Pawn, direction: Vector2):
	var cell_start = obst.world_to_map(pawn.position)
	var cell_target = cell_start + direction
	var cell_tile_id = obst.get_cellv(cell_target)
	match cell_tile_id:
		-1:
			return obst.map_to_world(cell_target)
	return null
	
func update_shadow(pos: Vector2, fow: Array, distance: int):
	fog.update_shadows(fow)
