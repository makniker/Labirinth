extends Node

onready var fog = $Fog
onready var player = $Player
onready var grass = $Grass
onready var obst = $Obstacles

export(PackedScene) var light_source_scene = preload("res://grid_movement/pawns/LightSource.tscn")

var lights_sources = [Vector2(5, 5)]

var player_fow = Array()

func _ready():
	obst.update_obst()
	fog.set_all_set_visible(false)
	spawn_pawn(player, Vector2(3, 3))
	place_random_light_sources(0)
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
	pawn.position = pos * 16

func is_in_fow(pawn1: Pawn, pawn2: Pawn) -> bool:
	if pawn1.position != pawn2.position:
		var direction = pawn1.position.direction_to(pawn2.position)
		var vec2 = pawn1.position
		while vec2 != pawn2.position:
			if obst.is_wall(obst.world_to_map(vec2)):
				return false
			vec2 += direction
	return true

func update_shadows():
	fog.set_all_set_visible(false)
	for child in get_children():
		if child is Pawn:
				if is_in_fow(player, child):
					update_shadow(obst.world_to_map(child.position), 5)
		
func request_move(pawn: Pawn, direction: Vector2):
	var cell_start = obst.world_to_map(pawn.position)
	var cell_target = cell_start + direction
	var cell_tile_id = obst.get_cellv(cell_target)
	match cell_tile_id:
		-1:
			return obst.map_to_world(cell_target)
	return null
	
func update_shadow(pos: Vector2, distance: int):
	fog.update_shadows(obst.calculate_fow(pos, distance))
