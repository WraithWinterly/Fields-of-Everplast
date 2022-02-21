extends Node2D

export(String) var sign_text = "Default Sign Text"


func _ready() -> void:
	$Sign/Label.text = sign_text
	$Sign.frame = LevelController.current_world - 1


func _on_CollisionShape2D_body_entered(body: Node) -> void:
	if body is Player:
		$Sign/AnimationPlayer.play("show")


func _on_CollisionShape2D_body_exited(body: Node) -> void:
	if body is Player:
		$Sign/AnimationPlayer.play_backwards("show")
