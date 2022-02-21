extends Sprite


func _ready() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = 30204
	rng.randomize()
	if LevelController.current_world == 1:
			rng.randomize()
			frame = rng.randi_range(0, 2)
	else: if LevelController.current_world == 2:
			rng.randomize()
			frame = rng.randi_range(3, 5)
