extends Node

onready var player: Player = $"../../"
onready var fsm: Node = $"../"


func _process(delta: float) -> void:
	fsm.look_for_states()
	if Main.get_action_strength().x != 0 or \
			Main.get_action_strength().y != 0:
		fsm.change_state(fsm.water_move)


func _physics_process(delta: float) -> void:
		player.basic_movement(delta)


func start():
	player.current_gravity = player.water_gravity


func stop():
	player.current_gravity = player.normal_gravity
	player.current_speed = 0

