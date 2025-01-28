extends Node


@export var card_scene: PackedScene

var points: PackedVector2Array

@onready var transparent_window: Node

func _ready() -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	get_window().position = Vector2(3200, 420)
	GlobalEvents.udp_keyboard_event.connect(on_udp_keyboard_event)
	transparent_window = get_tree().get_first_node_in_group("transparent_window")
	if transparent_window != null:
		transparent_window.SetClickThrough(true)


func on_udp_keyboard_event(key: String) -> void:
	var card_instance: Node2D = card_scene.instantiate()
	add_child(card_instance)
	key = key.replace("'", "")
	card_instance.update_text(key)
	card_instance.global_position = Vector2(randi_range(480, 500), 200)
