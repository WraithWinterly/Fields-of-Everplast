extends KinematicBody2D
class_name Enemy

export var health: int = 1
export var speed: int = 15
export var knockback: int = 15
export var damage: int = 20
export var gravity: int = 20
export var coin_amount: int = 1
export var respawn: bool = true
export var stay_on_land: bool = true
export var friendly: bool = false
export var invincible: bool = false
export var multiple_frames: bool = false
export var frame_count: int = 0
export var spiked_enemy: bool = false

onready var visibile_notifier: VisibilityNotifier2D = $VisibilityNotifier2D
onready var label_animation_player: AnimationPlayer = $Label/AnimationPlayer
onready var animation_player: AnimationPlayer = $SpriteHolder/AnimatedSprite/AnimationPlayer
onready var flip_animation_player: AnimationPlayer = $SpriteHolder/AnimatedSprite/FlipAnimationPlayer
onready var animated_sprite: AnimatedSprite = $SpriteHolder/AnimatedSprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var raycast_floor: RayCast2D = $RayCastFloor
onready var raycast_wall: RayCast2D = $RayCastWall
onready var respawn_timer: Timer = $Timer
onready var hit_area: Area2D = $HitArea
onready var label: Label = $Label

var max_health: int = 0

var water_enemy: bool = false
var check_for_player: bool = false
var facing_right: bool = true
var alive: bool = true


func _ready() -> void:
	if multiple_frames:
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		rng.seed = 340985922384907
		rng.randomize()
		var s = get_node_or_null("Sprite")
		if not s == null: s.frame = rng.randi_range(0, frame_count)
	if friendly:
		coin_amount = 0
		damage = 0
	hit_area.set_deferred("monitoring", true)
	collision_shape.set_deferred("disabled", false)
	max_health = health
	label.hide()
	knockback *= 10
	gravity *= 100
	visibile_notifier.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	hit_area.connect("body_entered", self, "_on_HitArea_body_entered")
	hit_area.connect("body_exited", self, "_on_HitArea_body_exited")
	revive()


func _physics_process(delta: float) -> void:
	if (not raycast_floor.is_colliding() and stay_on_land) or raycast_wall.is_colliding():
		if facing_right:
			facing_right = false
			raycast_floor.position = Vector2(-3, 4)
			raycast_wall.cast_to = Vector2(-7, 0)
			flip_animation_player.play("flip")
		else:
			facing_right = true
			raycast_floor.position = Vector2(11, 4)
			raycast_wall.cast_to = Vector2(7, 0)
			flip_animation_player.play_backwards("flip")
	# When a player decides to keep colliding with the enemy while they are hit
	if check_for_player:
		var bodies = hit_area.get_overlapping_bodies()
		for body in bodies:
			if body is Player:
				if not body.invincible:
					Signals.emit_signal("player_hurt_from_enemy", knockback, damage)

	move_and_slide(Vector2(speed, delta * gravity) if facing_right \
			else Vector2(-speed, delta * gravity))


func _on_HitArea_body_entered(body: Node):
	if body is Player:
		if (body.was_falling or body.falling) and not invincible:
			health -= 1
			if spiked_enemy:
				Signals.emit_signal("player_hurt_from_enemy", knockback, damage)
			if health <= 0:
				Signals.emit_signal("player_killed_enemy", damage, coin_amount)
				animation_player.stop()
				if $SpriteHolder/AnimatedSprite.scale.x == 1:
					animation_player.play("death")
				else:
					animation_player.play("death_invert")
				if not friendly:
					if label_animation_player.is_playing():
						label_animation_player.stop()
					label_animation_player.play("label")
				hit_area.set_deferred("monitoring", false)
				collision_shape.set_deferred("disabled", true)
				alive = false
				set_physics_process(false)
				var health_label_amount = max_health - health
				label.text = "%s / %s" % [health_label_amount, max_health]
			else:
				if not friendly:
					Signals.emit_signal("player_hurt_enemy", damage)
					$AudioStreamPlayer.play()
					#animation_player.stop()
					if $SpriteHolder/AnimatedSprite.scale.x == 1:
						animation_player.play("hurt")
					else:
						animation_player.play("hurt_invert")
					if label_animation_player.is_playing():
						label_animation_player.stop()
					label_animation_player.play("label")
					var health_label_amount = max_health - health
					label.text = "%s / %s" % [health_label_amount, max_health]
		else:
			if not body.invincible:
				Signals.emit_signal("player_hurt_from_enemy", knockback, damage)
				check_for_player = true

func _on_HitArea_body_exited(body: Node):
	check_for_player = false

func revive():
	collision_shape.set_deferred("disabled", false)
	hit_area.set_deferred("monitoring", true)
	label.hide()
	health = max_health
	set_physics_process(true)
	animated_sprite.modulate = Color(1, 1, 1, 1)
	animated_sprite.scale = Vector2(1, 1)
	animated_sprite.position = Vector2(0, 0)
	alive = true


func _on_VisibilityNotifier2D_screen_exited():
	if alive: return
	if respawn_timer.is_stopped():
		respawn_timer.call_deferred("start")
		#respawn_timer.start()


func _on_Timer_timeout() -> void:
	if not visibile_notifier.is_on_screen():
		revive()
