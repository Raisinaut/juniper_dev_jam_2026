class_name SpriteTrail
extends Node2D

signal emptied

@export var sprite : Sprite2D
@export var interval : float = 0.01
@export var scale_factor : float = 1.0

var emitting = true :
	set(val): emitting = val; if emitting: start_spawn_timer()
var spawn_timer : SceneTreeTimer
var list : Array = [] : set = set_list

func _ready() -> void:
	start_spawn_timer()

func start_spawn_timer() -> void:
	spawn_timer = get_tree().create_timer(interval)
	spawn_timer.timeout.connect(spawn_sprite)

func spawn_sprite() -> void:
	if !emitting:
		return
	if !sprite:
		push_warning("No sprite to duplicate")
		return
	var s = sprite.duplicate()
	call_deferred("add_child", s)
	list.append(s)
	setup_duplicate(s)
	fade_and_delete(s)
	start_spawn_timer()

func setup_duplicate(s : Sprite2D) -> void:
	s.top_level = true
	s.global_position = sprite.global_position
	s.rotation = sprite.global_rotation
	s.tree_exited.connect(remove_from_list.bind(s))
	s.scale *= scale_factor
	

func fade_and_delete(s : Sprite2D) -> void:
	var t = create_tween()
	s.modulate.a = 0.3
	t.tween_property(s, "modulate:a", 0, 0.1)
	await t.finished
	s.queue_free()

func remove_from_list(s : Sprite2D) -> void:
	if list.has(s):
		list.erase(s)

func set_list(l : Array) -> void:
	list = l
	if list.size() == 0:
		emptied.emit()
