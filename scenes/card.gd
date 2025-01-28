extends RigidBody2D

@onready var label: Label = $Control/VBoxContainer/PanelContainer/Label
@onready var v_box_container: VBoxContainer = $Control/VBoxContainer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func update_text(text: String) -> void:
	if len(text) > 4:
		collision_shape_2d.move_local_x(32)
		v_box_container.set_size(Vector2(100, 32))

	label.text = text
	tween_animation()


func tween_animation() -> void:
	var tween: Tween = create_tween()

	tween.tween_property(self, "scale", Vector2.ONE, .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()

	var scale_tween: Tween = create_tween()

	scale_tween.tween_property(self, "scale", Vector2.ONE * 2, .15)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	scale_tween.tween_property(self, "scale", Vector2.ONE, .15)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	scale_tween.tween_property(self, "scale", Vector2.ZERO, 2)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	scale_tween.tween_callback(queue_free)
