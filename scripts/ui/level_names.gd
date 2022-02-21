extends Label

onready var main: Main = get_tree().root.get_node("Main")

func _ready() -> void:
	Signals.connect("change_level", self, "_change_level")
	yield(get_tree().create_timer(0.1), "timeout")
	_change_level(PlayerStats.data.world, PlayerStats.data.level, false)


func _change_level(world: int, level: int, _from_start: bool) -> void:
	yield(get_tree().root.get_node("/root/Main/GUI/FadePlayer/CanvasLayer/FadeRect/AnimationPlayer"), "animation_finished")
	if LevelController.current_world == 4:
		text = "%s - FINAL" % main.world_names[world - 1]
	else:
		text = "%s - %s" % [main.world_names[world - 1], level]
