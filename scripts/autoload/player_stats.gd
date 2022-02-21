extends Node

const FILE: String = \
		"user://save.json"

var data: Dictionary = {
	"max_health": 100,
	"health": 100,
	"coins": 0,
	"level": 1,
	"world": 1,
	"game_beat": false
}

var started_from_erase: bool = false


func _enter_tree() -> void:
	Signals.connect("coin_collected", self, "_coin_collected")
	Signals.connect("player_hurt_from_enemy", self, "_player_hurt_from_enemy")
	Signals.connect("food_collected", self, "_food_collected")
	Signals.connect("save", self, "save_stats")
	load_stats()
	if started_from_erase:
		$GUI/Notification.show_notification("Save Erased!")
		started_from_erase = false


func save_stats() -> void:
	data.world = LevelController.current_world
	data.level = LevelController.current_level
	var file: File = File.new()
	file.open(FILE, File.WRITE)
	file.store_string(to_json(data))
	file.close()
	load_stats()


func load_stats() -> void:
	var file: File = File.new()
	if file.file_exists(FILE):
		file.open(FILE, File.READ)
		var loaded_data = parse_json(file.get_as_text())
		file.close()
		if typeof(loaded_data) == TYPE_DICTIONARY:
			data = loaded_data
			# Prevent crash for people starting a new save file
			if data.world == 0:
				data.world = 1
			if data.level == 0:
				data.level = 1
			print("Your Game Stats: %s" % data)
		else: save_stats()
	else: save_stats()


func _coin_collected(amount) -> void:
	data.coins += amount;


func _player_hurt_from_enemy(knockback, damage) -> void:
	set_health(data.health - damage)


func _food_collected(amount: int) -> void:
	set_health(data.health + amount)


func set_health(new_value):
	data.health = new_value
	data.health = clamp(data.health, 0, data.max_health)


func reset_stats():
	data.health = 100
	data.level = 1
	data.world = 1
	data.game_beat = false
	data.max_health = 100
	data.coins = 0
	LevelController.current_world = 1
	LevelController.current_level = 1
	save_stats()
	get_viewport().get_node("Main/GUI/Notification").show_notification("Save Data Erased", 1)
	MusicController._change_level_no_delay(1)
	get_tree().change_scene("res://scenes/main.tscn")
