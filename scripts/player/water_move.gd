extends Node

onready var fsm: Node = $"../"
onready var player: Player = $"../../"


func _process(delta: float) -> void:
	if Main.get_action_strength().x != 0 or \
			Main.get_action_strength().y != 0:
		set_input_speed()
		fsm.look_for_states()
	elif player.is_on_floor(): fsm.change_state(fsm.water_idle)


func basic_movement(var delta: float):
	down_check()
	player.current_speed *= Main.get_action_strength().x
	player.linear_velocity.x = lerp(
			player.linear_velocity.x, player.current_speed,
			player.current_lerp_speed
			)
	player.linear_velocity.y += delta * player.current_gravity
	player.linear_velocity = player.move_and_slide(
			player.linear_velocity,
			Vector2.UP
			)
	player.falling = player.linear_velocity.y > 0


func _physics_process(var delta: float) -> void:
	sprint_and_jump(delta)
	basic_movement(delta)


func set_input_speed() -> void:
	player.walking = Main.get_action_strength().x != 0
	player.current_speed = player.water_speed


func sprint_and_jump(delta: float) -> void:
	if Input.is_action_just_pressed("move_jump") or (player.is_on_floor() and \
			Input.is_action_pressed("move_jump")):
		player.air_time = 0
		player.linear_velocity.y = -player.water_jump_speed
	player.current_lerp_speed = player.lerp_speed_water


func down_check() -> void:
	if player.is_on_floor() and \
			Input.is_action_just_pressed("move_down") and not\
			player.down_check_cast.is_colliding():
		player.position.y += 2


func start():
	player.current_gravity = player.water_gravity


func stop():
	player.current_gravity = player.normal_gravity
	player.current_speed = 0
