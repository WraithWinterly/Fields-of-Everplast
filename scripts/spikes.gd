extends Node2D

var damage: int = 30
var knockback: int = 150
var check_for_player: bool = false


func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 349580734908573498
	rng.randomize()
	$Sprite.frame = rng.randi_range(0, 3)
	$Area2D.connect("body_entered", self, "_on_Area2D_body_entered")
	$Area2D.connect("body_exited", self, "_on_Area2D_body_exited")


func _physics_process(delta: float) -> void:
		var bodies = $Area2D.get_overlapping_bodies()
		for body in bodies:
			if body is Player:
				if not body.invincible:
					Signals.emit_signal("player_hurt_from_enemy", knockback, damage)


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		if not body.invincible:
			Signals.emit_signal("player_hurt_from_enemy", knockback, damage)
			check_for_player = false


func _on_Area2D_body_exited(body: Node) -> void:
	if body is Player:
		check_for_player = false
