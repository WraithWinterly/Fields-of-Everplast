extends Node

onready var fsm: Node = $"../"
onready var player: Player = $"../../"


func _physics_process(delta: float) -> void:
	if Main.get_action_strength().x != 0 or \
			not player.is_on_floor():
		player.set_input_speed()
		fsm.look_for_states()
	else:
		fsm.change_state(fsm.idle)
	sprint_and_jump(delta)
	player.basic_movement(delta)


func sprint_and_jump(delta: float) -> void:
	if player.is_on_floor():
		if Input.is_action_just_pressed("move_jump") or player.use_buffer:
			get_parent().get_parent().get_node("Jump").play()
			player.air_time = 0
			player.linear_velocity.y = -player.jump_speed
		player.use_buffer = false
		player.sprinting = Input.is_action_pressed("move_sprint")
		player.current_lerp_speed = player.lerp_speed_sprint \
				if player.sprinting else player.lerp_speed_walk
	elif Input.is_action_just_pressed("move_jump"):
		player.use_buffer = true
		get_parent().get_parent().get_node("Buffer").start(0.1)

#	else:
#		if Input.is_action_pressed("move_jump") and not player.falling:
#			player.air_time += delta
#			player.current_lerp_speed = player.lerp_speed_air
#			player.linear_velocity.y -= player.rise_force \
#					* pow(0.5, player.air_time * 5)
	player.rise_force = player.base_rise_force + player.linear_velocity.x \
			* player.jump_boost_velx if \
	Input.is_action_pressed("move_right") else player.base_rise_force + \
			player.linear_velocity.x * -player.jump_boost_velx


func start():
	player.current_gravity = player.normal_gravity
	if Input.is_action_just_pressed("move_jump") and player.is_on_floor():
		player.air_time = 0
		player.linear_velocity.y -= player.jump_speed


func stop():
	player.current_speed = 0


func _on_Buffer_timeout() -> void:
	#print("timeout")
	player.use_buffer = false
