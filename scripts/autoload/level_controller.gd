extends Node

onready var main: Main = $"/root/Main"

var is_initial_load = true
var run_from_start = true
var current_world: int = 1
var current_level: int = 1


func _ready() -> void:
	Signals.connect("change_level", self, "_change_level")
	var prev_level = get_node_or_null("/root/Main/Level")
	if not prev_level == null: prev_level.call_deferred("free")


func _change_level(world: int, level: int, from_start: bool):
	Signals.in_game = true
	get_tree().paused = true
	if not is_initial_load:
		yield(get_tree().root.get_node("/root/Main/GUI/FadePlayer/CanvasLayer/FadeRect/AnimationPlayer"), "animation_finished")
	current_world = world
	current_level = level
	run_from_start = from_start
	var prev_level = get_node_or_null("/root/Main/Level")
	if not prev_level == null: prev_level.call_deferred("free")
	yield(get_tree(), "idle_frame")
	var new_level: PackedScene = load("res://scenes/world%s/level%s.tscn"
			% [world, level])
	get_viewport().get_node("Main").call_deferred("add_child", new_level.instance(), true)
	get_tree().paused = false
	if is_initial_load:
		is_initial_load = false
		return
	if from_start:
		Signals.emit_signal("save")

