extends Control
class_name Main

export(String, "release,beta,alpha,dev") var version_prefix = "dev"
export var version_numbers: Array = [0, 0]
export var world_names: Array = ["", "", "", ""]

var version: String = ""
var started_from_erase = false


static func get_action_strength() -> Vector2:
	return Vector2(
			Input.get_action_strength("move_right") - \
			Input.get_action_strength("move_left"),
			Input.get_action_strength("move_jump")
	)


func _enter_tree() -> void:
	version = "v%s.%s-%s" % [version_numbers[0], version_numbers[1], version_prefix]
	print("Fields of Elysium: %s" % version)


func _ready() -> void:
	VisualServer.set_default_clear_color(Color(1, 1, 1, 1))
	OS.min_window_size = Vector2(1280, 720)



func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func end():
	$GUI/Notification.show_notification("Game Completed!")
	$GUI/End/AnimationPlayer.play("default", 0.2)
	$GUI/TSButtons.hide()
	PlayerStats.data.max_health = 75
	PlayerStats.data.world = 1
	PlayerStats.data.level = 1
	LevelController.current_world = 1
	LevelController.current_level = 1
	PlayerStats.data.health = 75
	PlayerStats.data.game_beat = true
	PlayerStats.save_stats()

# Cheating for testing
#func _input(event):
#    if Input.is_key_pressed(KEY_DELETE):
#        PlayerStats.data.world = 4
#        LevelController.current_world = 4
#        PlayerStats.data.level = 1
#        PlayerStats.data.game_beat = true
#        PlayerStats.save_stats()
