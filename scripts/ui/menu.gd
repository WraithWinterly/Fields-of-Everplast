extends Control

onready var continue_button = $HBoxContainer/Continue
onready var settings_button = $HBoxContainer/Settings
onready var select_button = $HBoxContainer/SelectWorld
onready var quit_button = $HBoxContainer/Quit


func _ready():
	continue_button.connect("pressed", self, "_on_Continue_pressed")
	settings_button.connect("pressed", self, "_on_Settings_pressed")
	select_button.connect("pressed", self, "_on_SelectWorld_pressed")
	quit_button.connect("pressed", self, "_on_Quit_pressed")
	continue_button.grab_focus()
	yield(get_tree().create_timer(1), "timeout")
	if PlayerStats.data.max_health == 75:
		PlayerStats.data.game_beat = true
	_on_Menu_visibility_changed()


func _on_Continue_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	Signals.emit_signal("change_level", PlayerStats.data.world, PlayerStats.data.level, true)
	get_parent().get_node(@"TSButtons").show()
	get_parent().get_node(@"HUD").show()
	yield(get_parent().get_node(@"FadePlayer/CanvasLayer/FadeRect/AnimationPlayer"), "animation_finished")
	hide()


func _on_Settings_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	$ResetPopup.popup_centered()


func _on_SelectWorld_pressed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	$HBoxContainer/Continue.disabled = true
	$HBoxContainer/Settings.disabled = true
	$HBoxContainer/SelectWorld.disabled = true
	$HBoxContainer/Quit.disabled = true
	$WorldSelector.popup()


func enable_buttons():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	$HBoxContainer/Continue.disabled = false
	$HBoxContainer/Settings.disabled = false
	$HBoxContainer/SelectWorld.disabled = false
	$HBoxContainer/Quit.disabled = false
	$HBoxContainer/SelectWorld.grab_focus()


func _on_Quit_pressed():
	get_tree().quit()


func _on_ResetPopup_confirmed():
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	PlayerStats.reset_stats()



func _on_ResetPopup_popup_hide() -> void:
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()


func _on_Menu_visibility_changed():
	if PlayerStats.data.game_beat:
		select_button.show()
	else:
		select_button.show()
		#select_button.hide()
	if PlayerStats.data.world == 1 and PlayerStats.data.level == 1 and \
			PlayerStats.data.coins == 0 and PlayerStats.data.health == 100:
		$HBoxContainer/Settings.hide()
	else: settings_button.show()


func _on_EverplastLink_pressed() -> void:
	get_viewport().get_node("Main/GUI/AudioStreamPlayer").play()
	OS.shell_open("https://store.steampowered.com/app/1896630/Everplast/")
