extends KinematicBody2D
class_name Player

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var animated_sprite_animation_player: AnimationPlayer = \
			$AnimatedSprite/AnimationPlayer
onready var down_check_cast: RayCast2D = $Checks/Down
onready var up_check_cast: RayCast2D = $Checks/Up
onready var invincible_timer: Timer = $InvincibleTimer
onready var fsm = $FSM
onready var wall_checks = [$Checks/WallLeft, $Checks/WallRight]

const water_jump_speed: int = 65

const water_speed: int = 64
const ladder_speed: int = 75

const water_gravity: int = 150
const ladder_gravity: int = 1
const out_water_boost: int = 75
const water_suction: int = 50

const lerp_speed_air: float = 0.03
const lerp_speed_water: float = 0.04
const jump_boost_velx: float = 0.013

var audio_effect_filter: AudioEffectFilter = AudioEffectFilter.new()

var linear_velocity: Vector2 = Vector2.ZERO

var base_rise_force: float = 14
var lerp_speed_sprint: float = 0.07
var lerp_speed_walk: float = 0.08
var current_gravity: int

var sprint_speed: float = 100
var walk_speed: float = 65
var air_time: float = 0
var current_lerp_speed: float = 0.08
var current_speed: float = 0

var jump_speed: int = 155
var rise_force: int = 1

var climbing_ladder: bool = false
var invincible: bool = false
var sprinting: bool = false
var walking: bool = false
var falling: bool = false
var was_falling: bool = false
var in_water: bool = false
var waiting_frame: bool = false

var use_buffer: bool = false

onready var normal_gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
# CHEAT!!!
#func _unhandled_input(event):
#    if Input.is_key_pressed(KEY_END):
#        var level_and = get_viewport().get_node_or_null("Main/Level/LevelSwitcherEnd")
#        if level_and != null:
#            position.x = level_and.position.x
#            position.y = level_and.position.y - 20

func _ready() -> void:
	Signals.connect("player_hurt_from_enemy", self, "take_damage")
	Signals.connect("player_hurt_enemy", self, "_player_hurt_enemy")
	Signals.connect("player_killed_enemy", self, "_player_killed_enemy")
	Signals.connect("player_hurt_boss", self, "_player_hurt_boss")
	get_tree().connect("physics_frame", self, "_physics_frame")
	if LevelController.current_world == 3:
		lerp_speed_sprint /= 3
		lerp_speed_walk /= 3
		walk_speed *= 1.2
		sprint_speed *= 1.2

	elif LevelController.current_world == 4:
		normal_gravity /= 2
		base_rise_force /= 1.5

	current_gravity = normal_gravity

	animated_sprite.set_as_toplevel(true)



func _process(delta: float) -> void:
	animated_sprite.global_position = lerp(animated_sprite.global_position, global_position, 30 * delta)



func _physics_process(delta: float) -> void:
	if was_falling and is_on_floor():
		waiting_frame = true

func _physics_frame():
	if waiting_frame:
		was_falling = false

func basic_movement(var delta: float):
	#print(str(linear_velocity.y))

	current_speed *= Main.get_action_strength().x

	linear_velocity.x = lerp(linear_velocity.x, current_speed, current_lerp_speed)

	linear_velocity.y += delta * current_gravity
	linear_velocity = move_and_slide(linear_velocity, Vector2.UP)

	falling = linear_velocity.y > 0

	if falling:
		was_falling = true

	down_check()

func down_check() -> void:
	if is_on_floor() and Input.is_action_pressed("move_down") and not\
			down_check_cast.is_colliding():
		position.y += 2


func set_input_speed() -> void:
	walking = not Main.get_action_strength().x == 0
	current_speed = sprint_speed \
			if sprinting else walk_speed


func death() -> void:
	$AnimatedSprite/AnimationPlayer.play("death")
	yield($AnimatedSprite/AnimationPlayer, "animation_finished")
	Signals.emit_signal("change_level", PlayerStats.data.world,
			PlayerStats.data.level, true)
	linear_velocity = Vector2(0, 0)
	PlayerStats.data.health = 100


func take_damage(knockback: int, damage: int):
	if damage > 0:
		$Hurt.play()
	if in_water: knockback /= 2
	if invincible: return;
	air_time = 10
	rise_force = 0
	if not Input.is_action_just_pressed("move_jump"):
		linear_velocity.y = -knockback if not in_water else -knockback
	if damage > 0:
		linear_velocity.x = -knockback if linear_velocity.x >= 0 else knockback
		invincible = true
		invincible_timer.start()
		animated_sprite_animation_player.play("flash")
		if PlayerStats.data.health <= 0:
			death()


func _player_hurt_enemy(damage: int) -> void:
	#if not is_on_floor() and not Input.is_action_just_pressed("move_jump"):
		var new_jump_speed = jump_speed
		if in_water: new_jump_speed /= 2
		air_time = 0
		linear_velocity.y = -new_jump_speed

func _player_hurt_boss(damage: int, knockback: int) -> void:
	#if not is_on_floor() and not Input.is_action_just_pressed("move_jump"):
		air_time = 0
		linear_velocity.y = -knockback
		linear_velocity.x = -knockback if linear_velocity.x >= 0 else knockback
		var coin_inst: Area2D = load("res://scenes/coin.tscn").instance()
		coin_inst.position = Vector2(2, 12)
		call_deferred("add_child", coin_inst)

var final_played_once = false
func _on_EnemyAnimation_entered(body: Node):
	if body.is_in_group("Player"):
		if not final_played_once: $Camera2D/FinalEnemy.play("default")
		final_played_once = true


func _player_killed_enemy(damage: int, coin_amount: int):
	#if not is_on_floor() and not Input.is_action_just_pressed("move_jump"):
	var new_jump_speed = jump_speed
	if in_water: new_jump_speed /= 2
	air_time = 0
	linear_velocity.y = -new_jump_speed

	if not coin_amount == 0:
		for _n in range(coin_amount):
			var coin_inst: Area2D = load("res://scenes/coin.tscn").instance()
			coin_inst.position = Vector2(2, 12)
			call_deferred("add_child", coin_inst)


func _on_InvincibleTimer_timeout() -> void:
	invincible = false
	animated_sprite_animation_player.stop()
	animated_sprite.modulate = Color(1, 1, 1, 1)


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("water"):
		linear_velocity.y += water_suction
		in_water = true
		fsm.change_state(fsm.water_idle)
		AudioServer.add_bus_effect(0, audio_effect_filter)


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.is_in_group("water"):
		linear_velocity.y -= out_water_boost
		in_water = false
		fsm.change_state(fsm.idle)
		AudioServer.remove_bus_effect(0, 1)


