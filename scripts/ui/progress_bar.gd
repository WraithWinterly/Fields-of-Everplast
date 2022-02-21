extends ProgressBar


func _physics_process(delta: float) -> void:
	if not Signals.in_game: return
	if value > PlayerStats.data.health:
		value -= 1
		#yield(get_tree(), "physics_frame")
		return
	else: if value < PlayerStats.data.health:
		value += 1
		#yield(get_tree(), "physics_frame")
		return
	max_value = PlayerStats.data.max_health
