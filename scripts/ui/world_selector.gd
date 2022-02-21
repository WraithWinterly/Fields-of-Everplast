extends Panel

var world: int = 1
var level: int = 1

var in_menu: bool = false


func _ready():
	hide()
	$VBoxContainer/AddWorld.connect("pressed", self, "_on_AddWorld_pressed")
	$VBoxContainer/RemoveWorld.connect("pressed", self, "_on_RemoveWorld_pressed")
	$VBoxContainer/AddLevel.connect("pressed" , self, "_on_AddLevel_pressed")
	$VBoxContainer/RemoveLevel.connect("pressed", self, "_on_RemoveLevel_pressed")
	$VBoxContainer/GoToLevel.connect("pressed", self, "_on_GoToLevel_pressed")
	$VBoxContainer/Back.connect("pressed", self, "_on_Back_pressed")
	update()

func update():
	$VBoxContainer/SelectedLevelLabel.text = "Selected Level: %s - %s" % [world, level]
	if world == 4:
		if level != 1:
			level = 1
			update()
		$VBoxContainer/RemoveLevel.disabled = true
		$VBoxContainer/AddLevel.disabled = true
		$VBoxContainer/AddWorld.disabled = true
	else:
		$VBoxContainer/RemoveLevel.disabled = false
		$VBoxContainer/AddLevel.disabled = false
		$VBoxContainer/AddWorld.disabled = false
	$VBoxContainer/RemoveWorld.disabled = world == 1
	$VBoxContainer/AddLevel.disabled = level == 5 or world == 4
	$VBoxContainer/RemoveLevel.disabled = level == 1


func popup():
	show()
	$VBoxContainer/AddWorld.grab_focus()
	world = 1
	level = 1
	update()
	in_menu = true


func _on_RemoveWorld_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	world -= 1
	update()


func _on_AddWorld_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	world += 1
	update()


func _on_AddLevel_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	level += 1
	update()


func _on_RemoveLevel_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	level -= 1
	update()


func _on_GoToLevel_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	LevelController.current_world = world
	LevelController.current_level = level
	PlayerStats.data.world = world
	PlayerStats.data.level = level
	get_parent()._on_Continue_pressed()
	_on_Back_pressed()


func _on_Back_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	hide()
	get_parent().enable_buttons()
	in_menu = false
