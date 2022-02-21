extends AnimatedSprite

onready var player: Player = $"../"
onready var fsm: Node = $"../FSM"
var use_walk_animation = false

var was_on_floor_moving: bool = true


func _process(delta: float) -> void:
	match fsm.current_state:
		fsm.idle:
			animation = "idle"
		fsm.move:
			if Main.get_action_strength().x > 0:
				flip_h = false
			elif Main.get_action_strength().x < 0:
				flip_h = true
			if player.is_on_floor():
				if not player.wall_checks[0].is_colliding() and not player.wall_checks[1].is_colliding():
					animation = "sprint" if player.sprinting else "walk"

					was_on_floor_moving = Main.get_action_strength().x != 0
				else:
					animation = "idle"
			else:
				if was_on_floor_moving:
					animation = "air_walk"
				else: animation = "air_idle"

		fsm.water_idle:
			animation = "idle"

		fsm.water_move:
			if Main.get_action_strength().x > 0:
				flip_h = false
			elif Main.get_action_strength().x < 0:
				flip_h = true
			animation = "walk"

		fsm.ladder:
			animation = "ladder"

		fsm.water_move:
				if Main.get_action_strength().x > 0:
					flip_h =false
				elif Main.get_action_strength().x < 0:
					flip_h = true
