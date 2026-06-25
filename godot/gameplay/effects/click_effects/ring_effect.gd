class_name RingEffect
extends Node2D

@export var max_radius : float = 30
@export var width : float = 3.0
@export var lifetime : float = 0.3

var radius : float = 0 : set = set_radius

func _ready() -> void:
	_expand().finished.connect(queue_free)

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE, false, width)

func set_radius(val) -> void:
	radius = val
	modulate.a = inverse_lerp(max_radius, 0, radius)
	queue_redraw()

func _expand() -> Tween:
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_method(set_radius, 0, max_radius, lifetime)
	return t
