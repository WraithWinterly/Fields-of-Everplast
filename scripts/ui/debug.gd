extends Label

onready var main:Main = get_tree().root.get_node("Main")

func _process(delta: float) -> void:
    text = "FPS: %s" % Engine.get_frames_per_second()
    text += "\n%s" % main.version
    var player: Player = get_node_or_null("/root/Main/Level/PlayerRoot/Player")
    if not player == null:
        text += "\nPlayer: %s" % str(player.fsm.current_state.name)
