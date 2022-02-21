extends Area2D

export var health_amount = 15

func _ready() -> void:
	connect("body_entered", self, "_on_Carrot_body_entered")


func _on_Carrot_body_entered(body: Node) -> void:
	if body is Player:
		$EatSound.play()
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimationPlayer.play("collected")
		Signals.emit_signal("food_collected", health_amount)

