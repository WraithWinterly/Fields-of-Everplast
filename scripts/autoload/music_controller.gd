extends Node

var audio_stream_player = AudioStreamPlayer.new()

var loaded_stream_name = ""
var stream_paths = [
	"res://assets/world1/anttis_instrumentals_feel_the_love.ogg",
	"res://assets/world2/anttis_instrumentals_simple_simplyfied.ogg",
	"res://assets/world3/anttis_instrumentals_rain.ogg",
	"res://assets/world4/anttis_instrumentals_wonderful_lie.ogg",
]

func _ready() -> void:
	Signals.connect("change_level", self, "_change_level")
	add_child(audio_stream_player, true)
	_change_level(PlayerStats.data.world, PlayerStats.data.level, true)
	pause_mode = PAUSE_MODE_PROCESS


func _change_level(world: int, _level: int, _from_start: bool):
	var fade_rect = get_node_or_null("/root/Main/GUI/FadePlayer/CanvasLayer/FadeRect/AnimationPlayer")
	if not fade_rect == null:
		yield(fade_rect, "animation_finished")
	var new_stream_name
	new_stream_name = stream_paths[world - 1] # arrays are 0 indexed, my worlds aren't
	if not new_stream_name == loaded_stream_name:
		audio_stream_player.stream = load(new_stream_name)
		loaded_stream_name = new_stream_name
		audio_stream_player.play()

func _change_level_no_delay(world: int):
	var fade_rect = get_node_or_null("/root/Main/GUI/FadePlayer/CanvasLayer/FadeRect/AnimationPlayer")
	if not fade_rect == null:
		yield(fade_rect, "animation_finished")
	var new_stream_name
	new_stream_name = stream_paths[world - 1] # arrays are 0 indexed, my worlds aren't
	if not new_stream_name == loaded_stream_name:
		audio_stream_player.stream = load(new_stream_name)
		loaded_stream_name = new_stream_name
		audio_stream_player.play()
