# DraggablePanel.gd - Attach to any panel you want to be draggable
extends PanelContainer

var drag_offset: Vector2
var dragging = false

# Allows the user to drag the panel
# Code provided by Dre Dyson (https://dredyson.com/the-hidden-truth-about-mouse-passthrough-in-godot-4-6-3-insider-tips-advanced-gotchas-and-the-complete-step-by-step-fix-guide-nobody-talks-about/)
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_offset = event.position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		position += event.position - drag_offset
