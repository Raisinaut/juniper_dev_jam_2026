extends Node2D

@onready var sprite: Sprite2D = $Sprite

var max_flick_rotation = 0.3

var rotation_tween : Tween = null

func flick() -> void:
	if rotation_tween: rotation_tween.kill()
	rotation_tween = create_tween()
	rotation_tween.tween_property(sprite, "rotation", -max_flick_rotation, 0.05)
	rotation_tween.tween_property(sprite, "rotation",  max_flick_rotation * 0.5, 0.05)
	rotation_tween.tween_property(sprite, "rotation", -max_flick_rotation * 0.2, 0.07)
	rotation_tween.tween_property(sprite, "rotation", 0, 0.05)
