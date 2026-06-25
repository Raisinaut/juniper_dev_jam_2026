extends Node2D

## Effect scene should be of type Node2D.
@export var effect : PackedScene

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and not event.is_echo():
			create_effect(get_global_mouse_position())

func create_effect(pos : Vector2) -> void:
	var inst : Node2D = effect.instantiate()
	call_deferred("add_child", inst)
	inst.global_position = pos
