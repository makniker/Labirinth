extends Pawn

const inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_down": Vector2.DOWN,
	"ui_up": Vector2.UP
}

onready var map_handler = get_parent()

var look_direction = Vector2()

func _ready():
	type = CellType.ACTOR
	pass

func _unhandled_input(event):
	for action in inputs.keys():
		if event.is_action_pressed(action):
			look_direction = inputs[action]
			var target_position = map_handler.request_move(self, inputs[action])
			if target_position:
				move_to(target_position)

func move_to(target_position):
	position = target_position
