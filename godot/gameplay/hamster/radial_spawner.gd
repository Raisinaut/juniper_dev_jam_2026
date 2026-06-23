class_name RadialSpawner
extends Node2D

@export var scene_to_spawn : PackedScene
@export var max_active = -1
@export var angle_interval : float = 0.65
@export var radius : float = 0
@export var constant_rotation_speed : float = 0.3

var rot_tween : Tween = null

var active_count : int = 0 : set = set_max_active

func set_max_active(val : int) -> void:
	if max_active >= 0 and val > max_active:
			return
	var last_count = active_count
	active_count = val
	if last_count > active_count:
		for i in last_count - active_count:
			despawn()
	elif active_count > last_count:
		for i in active_count - last_count:
			spawn()

func _process(delta: float) -> void:
	rotation += constant_rotation_speed * delta

func update_rotation() -> void:
	if rot_tween: rot_tween.kill()
	var target_rotation = get_max_angle() * 0.5
	rot_tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	rot_tween.tween_property(self, "rotation", target_rotation, 0.9)

func despawn() -> void:
	if get_child_count() > 0:
		get_child(-1).queue_free()
	else:
		push_warning("No entities left to despawn.")

func spawn() -> void:
	var pivot = await create_pivot()
	var inst = scene_to_spawn.instantiate()
	pivot.call_deferred("add_child", inst)
	pivot.rotation = -get_max_angle()
	inst.position.y = radius

func create_pivot() -> Node2D:
	var pivot = Node2D.new()
	call_deferred("add_child", pivot)
	await pivot.ready
	return pivot

func get_max_angle() -> float:
	return angle_interval * (active_count - 1)
