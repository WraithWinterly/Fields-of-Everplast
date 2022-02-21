extends Control
class_name FadePlayer

onready var fade_player: AnimationPlayer = $CanvasLayer/FadeRect/AnimationPlayer
onready var loading_symbol: TextureRect = $CanvasLayer/FadeRect/LoadingSymbol
onready var loading_label: Label = $CanvasLayer/FadeRect/Label

func _ready() -> void:
	Signals.connect("change_level", self, "_change_level")
	loading_symbol.hide()
	loading_label.hide()
	play(true)


func _change_level(_world:int, _level:int, _from_start:bool):
	loading_symbol.show()
	loading_label.show()
	play(false, 2)
	yield(fade_player, "animation_finished")
	play(true)
	yield(fade_player, "animation_finished")
	loading_symbol.hide()
	loading_label.hide()


func play(fadeOut: bool, speed: float = 1):
	if fadeOut:
		fade_player.stop()
		fade_player.playback_speed = speed
		fade_player.play("fade")
	else:
		fade_player.stop()
		fade_player.playback_speed = speed
		fade_player.play_backwards("fade", speed)
