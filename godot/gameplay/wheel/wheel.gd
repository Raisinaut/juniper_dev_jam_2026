@tool
class_name Wheel
extends Node2D

signal tick_passed

@export var radius : float = 100 : 
	set(val): radius = val; queue_redraw()
@export_range(0, 1) var fill : float = 0 : 
	set(val): fill = val; queue_redraw()
@export_range(0, 1, 1, "or_greater")  var tick_count : int = 10:
	set(val): tick_count = val; queue_redraw()
@export_range(0, 1, 1, "or_greater")  var tick_length : int = 5:
	set(val): tick_length = val; queue_redraw()
@export_range(0, 10, 0.01, "or_greater")  var tick_width : float = 2:
	set(val): tick_width = val; queue_redraw()

@export var test_spin : bool = false :
	set(val): test_spin = val; reset_rotation()

var rotation_speed : float = 1
var rotation_since_tick : float = 0.0


func _ready() -> void:
	reset_rotation()

func _process(delta: float) -> void:
	if Engine.is_editor_hint() and not test_spin:
		return
	spin(delta)

func spin(delta : float):
	var rotation_amount = rotation_speed * delta
	rotation = wrapf(rotation + rotation_amount, 0, 2 * PI)
	rotation_since_tick += rotation_amount
	var ticks_passed : int = floor(rotation_since_tick / get_tick_angle_separation())
	if ticks_passed > 0:
		if not Engine.is_editor_hint():
			tick_passed.emit()
			print(ticks_passed, " tick passed")
		rotation_since_tick = 0

func get_tick_angle_separation() -> float:
	return 2 * PI / tick_count

func reset_rotation() -> void:
	rotation = 0


# DRAWING ----------------------------------------------------------------------
func _draw() -> void:
	draw_ticks()
	draw_ring()

func draw_ticks() -> void:
	var tick_lines : PackedVector2Array = []
	for i in tick_count:
		var angle = remap(i, 0, tick_count, 0, 2 * PI)
		var v = Vector2.from_angle(angle)
		tick_lines.append(v * (radius - 1)) # place behind circle a bit
		tick_lines.append(v * (radius + tick_length))
	if tick_lines.size() >= 2:
		draw_multiline(tick_lines, Color.WHITE, tick_width)

func draw_ring() -> void:
	var r_offset = radius * fill
	var w = radius * 2 * fill
	draw_circle(Vector2.ZERO, radius - r_offset, Color.WHITE, false, w, false)
