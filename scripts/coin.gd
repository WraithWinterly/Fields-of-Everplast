extends Area2D


func _on_Coin_body_entered(body: Node) -> void:
	if not body is Player: return
	Signals.emit_signal("coin_collected", 1)
	$AudioStreamPlayer2D.play()
	$AnimationPlayer.play("collect")
	$CollisionShape2D.set_deferred("disabled", true)
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = 349093452345908
	rng.randomize()
	$AudioStreamPlayer2D.pitch_scale = rng.randf_range(0.7, 0.8)
	yield($AnimationPlayer, "animation_finished")
	call_deferred("free")
