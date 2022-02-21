extends Label


func _ready() -> void:
	Signals.connect("coin_collected", self, "_coin_collected")
	text = str(PlayerStats.data.coins)


func _coin_collected(amount: int):
	text = str(PlayerStats.data.coins)
