extends Label


func _ready():
    text = get_viewport().get_node("Main").version


