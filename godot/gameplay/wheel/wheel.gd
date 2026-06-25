@tool
class_name Wheel
extends Node2D

signal tick_passed(qty : int)
signal rpm_changed(value : float)
signal clicked

@onready var mouse_area: Area2D = $MouseArea


@export var radius : float = 100 : 
	set(val): radius = val; queue_redraw(); $MouseArea.set_shape_radius(radius)
@export_range(0, 1) var fill : float = 0 : 
	set(val): fill = val; queue_redraw()
@export_range(0, 1, 1, "or_greater")  var tick_count : int = 10:
	set(val): tick_count = val; queue_redraw()
@export_range(0, 1, 1, "or_greater")  var tick_length : int = 5:
	set(val): tick_length = val; queue_redraw()
@export_range(0, 10, 0.01, "or_greater")  var tick_width : float = 2:
	set(val): tick_width = val; queue_redraw()
@export_range(0, 10, 1, "or_greater")  var support_count : int = 6:
	set(val): support_count = val; queue_redraw()
@export_range(0, 10, 0.01, "or_greater")  var support_width : float = 8:
	set(val): support_width = val; queue_redraw()

@export var test_spin : bool = false :
	set(val): 
		test_spin = val
		rpm = 10 if test_spin else 0
		reset_rotation()

var rpm : float = 0.0 :
	set(val): rpm = val#; rpm_changed.emit(rpm)
var rpm_boost : float = 0.0
var rpm_boost_decrease_rate : float = 15.0
var last_rpm : float = 0
var rotation_since_tick : float = 0.0
var boost_tween : Tween = null


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	test_spin = false
	reset_rotation()
	mouse_area.mouse_clicked.connect(_on_mouse_area_clicked)

func _process(delta: float) -> void:
	if Engine.is_editor_hint() and not test_spin:
		return
	var last_rotation = rotation
	spin(delta)
	var curr_rotation = rotation
	var current_rpm = ((curr_rotation - last_rotation) / delta) * (60 / (2 * PI))
	if last_rpm != current_rpm and current_rpm > 0:
		rpm_changed.emit(current_rpm)

func spin(delta : float):
	var rotation_change = angular_velocity() * delta
	rotation = wrapf(rotation + rotation_change, 0, 2 * PI)
	rotation_since_tick += rotation_change
	var ticks_passed : float = rotation_since_tick / tick_angle_separation()
	if floor(ticks_passed) > 0:
		if not Engine.is_editor_hint():
			tick_passed.emit(floor(ticks_passed))
		var remaining_angle = ticks_passed - floor(ticks_passed)
		rotation_since_tick = remaining_angle * tick_angle_separation()

func tick_angle_separation() -> float:
	return 2 * PI / tick_count

func angular_velocity() -> float:
	return get_total_rpm() * 2 * PI / 60

func get_total_rpm() -> float:
	return rpm + rpm_boost

func reset_rotation() -> void:
	rotation = 0

func inner_radius() -> float:
	return radius * (1.0 - fill * 2)


# SIGNALS ----------------------------------------------------------------------
func _on_mouse_area_clicked() -> void:
	var click_rpm = AttributeManager.get_attribute_value("click_rpm")
	var click_power_count = AttributeManager.get_attribute_value("click_multiplier")
	rpm_boost += click_rpm * click_power_count
	# TWEEN BOOST BACK TO ZERO
	if boost_tween: boost_tween.kill()
	boost_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	boost_tween.tween_property(self, "rpm_boost", 0, 2.0)
	clicked.emit()


# DRAWING ----------------------------------------------------------------------
func _draw() -> void:
	draw_ticks()
	draw_ring()
	draw_supports()

func draw_supports() -> void:
	for i in support_count:
		var angle = remap(i, 0, support_count, 0, 2 * PI)
		var end_point = Vector2.from_angle(angle) * inner_radius()
		draw_line(Vector2.ZERO, end_point, Color.DARK_GRAY, support_width)

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
