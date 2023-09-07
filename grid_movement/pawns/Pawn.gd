class_name Pawn
extends Node2D


enum CellType { ACTOR, LIGHT_SOURCE, OBJECT }
#warning-ignore:unused_class_variable
export(CellType) var type = CellType.ACTOR

var active = true setget set_active


var light_range = 5;

func set_active(value):
	active = value
	set_process(value)
	set_process_input(value)

func spawn(pos: Vector2):
	position = pos
