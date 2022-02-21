extends Node

onready var fsm: Node = $"../"
onready var player: Player = $"../../"


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_up") and player.up_check_cast.is_colliding():
		player.basic_movement(delta)
		player.linear_velocity.y = -player.ladder_speed
		player.current_gravity = player.ladder_gravity
		player.set_input_speed()
	else:
		if player.in_water:
			fsm.change_state(fsm.water_move)
		else:
			fsm.change_state(fsm.idle)


func start():
	player.current_gravity = player.ladder_gravity


func stop():
	player.current_gravity = player.normal_gravity

