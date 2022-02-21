extends Camera2D

var down_pan_timer: float = 0
var up_pan_timer: float = 0

var panning_down: bool = false

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var player: Player = get_parent()


func _ready() -> void:
	var limit_left_top_position = get_node_or_null("/root/Main/Level/CameraPositions/TopLeft")
	var limit_right_bottom_position = get_node_or_null("/root/Main/Level/CameraPositions/BottomRight")
	if not limit_left_top_position == null and not limit_right_bottom_position == null:
		limit_left = limit_left_top_position.position.x
		limit_top = limit_left_top_position.position.y
		limit_right = limit_right_bottom_position.position.x
		limit_bottom =limit_right_bottom_position.position.y


func _physics_process(delta: float) -> void:
	pan_camera_input()


func pan_camera_input():
	if Input.is_action_pressed("move_down") and not \
			Input.is_action_pressed("move_up"):
		if Main.get_action_strength() == Vector2(0, 0) and player.is_on_floor():
			down_pan_timer += 1
		else: down_pan_timer = 0
	else:
		down_pan_timer = 0

	if down_pan_timer > 30:
		if !animation_player.is_playing() and offset.y < 35:
			animation_player.play("pan_down")
			panning_down = true
	else:
		if not offset == Vector2.ZERO and panning_down: \
			animation_player.play_backwards("pan_down")

	if Input.is_action_pressed("move_up") and not \
			Input.is_action_pressed("move_down"):
		if Main.get_action_strength() == Vector2(0, 0) and player.is_on_floor():
			up_pan_timer += 1
		else: up_pan_timer = 0
	else:
		up_pan_timer = 0

	if up_pan_timer > 30:
		if !animation_player.is_playing() && offset.y > -35:
			animation_player.play("pan_up")
			panning_down = false
	else:
		if not offset == Vector2.ZERO and not panning_down:\
			animation_player.play_backwards("pan_up")
