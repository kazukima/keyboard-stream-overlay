extends Node

signal udp_keyboard_event


func emit_udp_keyboard_event(key: String) -> void:
	udp_keyboard_event.emit(key)
