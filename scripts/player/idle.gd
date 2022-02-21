extends Node

onready var player: Player = $"../../"
onready var fsm = $"../"


func _physics_process(delta: float) -> void:
	fsm.look_for_states()
	if Main.get_action_strength().x != 0 or \
			Input.is_action_just_pressed("move_jump"):
		get_parent().get_parent().get_node("Jump").play()
		fsm.change_state(fsm.move)
	player.basic_movement(delta)


