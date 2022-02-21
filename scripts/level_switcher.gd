extends Area2D

export var new_world: int = 1
export var new_level: int = 1
export var from_start: bool = true

func _on_LevelSwitcher_body_entered(body: Node) -> void:
	if body is Player:
		Signals.emit_signal("change_level", new_world, new_level, from_start)
