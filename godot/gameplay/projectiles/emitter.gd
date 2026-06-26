class_name Emitter
extends Node2D

@export var emission_scene : PackedScene
@export var emission_speed : float = 0

func emit(direction : Vector2, parent : Node2D) -> void:
	var emission : Node2D = emission_scene.instantiate()
	parent.call_deferred("add_child", emission)
	await emission.ready
	emission.global_position = global_position
	emission.rotation = direction.angle()
