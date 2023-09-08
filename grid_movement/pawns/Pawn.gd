class_name Pawn
extends Node2D


enum CellType { ACTOR, LIGHT_SOURCE, OBJECT }
#warning-ignore:unused_class_variable
export(CellType) var type = CellType.ACTOR
var grid_size = 16

var light_range = 5;

func spawn(pos: Vector2):
	position = pos * grid_size


func get_position() -> Vector2:
	return position / grid_size
