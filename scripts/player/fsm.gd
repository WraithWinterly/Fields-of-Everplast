extends Node

onready var player: Player = get_parent()
onready var idle: Node = $Idle
onready var move: Node = $Move
onready var water_idle: Node = $WaterIdle
onready var water_move: Node = $WaterMove
onready var ladder: Node = $Ladder
onready var current_state: Node = $Idle


func _ready() -> void:
	for child in get_children():
		child.set_process(false)
		child.set_physics_process(false)
	idle.set_process(true)
	idle.set_physics_process(true)


func change_state(new_state: Node):
	current_state.set_process(false)
	current_state.set_physics_process(false)
	if current_state.has_method("stop"):
		current_state.call("stop")
	current_state = new_state
	if current_state.has_method("start"):
		current_state.call("start")

	current_state.set_process(true)
	current_state.set_physics_process(true)


func look_for_states():
	if player.up_check_cast.is_colliding() and Input.is_action_pressed("move_up"):
		change_state(ladder)
