extends Panel

onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var label:Label = $Label

func _ready() -> void:
	Signals.connect("save", self, "_save")


func show_notification(message: String, time: float = 1):
	label.text = message
	if !animation_player.is_playing():
		animation_player.playback_speed = time
		animation_player.play("notification")

func _save():
	show_notification("Saved Game!")
