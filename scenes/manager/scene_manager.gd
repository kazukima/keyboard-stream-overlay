extends Node

@onready var transparent_window: Node

func _ready() -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	get_window().position = Vector2(3200, 420)
	transparent_window = get_tree().get_first_node_in_group("transparent_window")
	if transparent_window != null:
		transparent_window.SetClickThrough(true)
