extends Control

onready var continue_button = $HBoxContainer/Continue
onready var return_button = $HBoxContainer/Return


func _ready():
	continue_button.connect("pressed", self, "_on_Continue_pressed")
	return_button.connect("pressed", self, "_on_Return_pressed")
	disable_buttons()


func _unhandled_input(event):
	if Input.is_action_just_pressed("pause") and Signals.in_game and $AnimationPlayer.is_playing() == false and not Signals.menu_locked:
		if get_tree().paused:
			disable_buttons()
			$AnimationPlayer.play_backwards("pause")
			get_tree().paused = false
		else:
			enable_buttons()
			show()
			$AnimationPlayer.play("pause")
			get_tree().paused = true
			continue_button.grab_focus()


func enable_buttons():
	continue_button.disabled = false
	return_button.disabled = false


func disable_buttons():
	continue_button.disabled = true
	return_button.disabled = true


func _on_Continue_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	disable_buttons()
	$AnimationPlayer.play_backwards("pause")
	get_tree().paused = false
	yield($AnimationPlayer, "animation_finished")
	hide()


func _on_Return_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	get_node("/root/Main/Level").call_deferred("free")
	get_node("/root/Main/GUI/HUD").hide()
	get_node("/root/Main/GUI/Menu").show()
	get_node("/root/Main/GUI/TSButtons").hide();
	Signals.in_game = false
	disable_buttons()
	$AnimationPlayer.play_backwards("pause")
	yield($AnimationPlayer, "animation_finished")
	hide()
	get_tree().paused = false
	get_node("/root/Main/GUI/Menu").continue_button.grab_focus()
