extends Area2D


func _on_DeathArea_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		Signals.emit_signal("player_hurt_from_enemy", 0, 99999)
