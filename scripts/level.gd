extends Node2D

func _ready() -> void:
	if LevelController.run_from_start:
		$Player.position = $PlayerPositions/Start.position
	else:
		$Player.position = $PlayerPositions/End.position
	if LevelController.current_world == 4 and LevelController.current_level == 1:
		$EnemyAnimation.connect("body_entered", get_node("/root/Main/Level/Player"), "_on_EnemyAnimation_entered")
