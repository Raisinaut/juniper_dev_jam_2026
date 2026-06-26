class_name ShakyCamera
extends Camera2D

@export var can_pivot := false
@export_range (0.0, 0.1, 0.01) var pivot_amount = 0.04
@export_range (0.1, 10, 0.1) var pivot_speed : float = 8
@export_range (1, 100, 1) var offset_speed : float = 5
@export_range (1, 100, 1) var move_speed : float = 10
@onready var shaker = $Shaker
@onready var initial_position = global_position

var target : Node2D
var target_position : Vector2
var pivot_target := Vector2.ZERO
var pivot_vector := Vector2.ZERO
var offset_target := Vector2.ZERO
var offset_vector := Vector2.ZERO

func small_shake() -> void:
	shaker.start(0.3, 30, 10, 0)

func _process(delta: float) -> void:
	update_pivot_vector(delta)
	update_offset_vector(delta)
	#follow_target(delta)

func update_pivot_vector(delta) -> void:
	if !can_pivot:
		pivot_target = Vector2.ZERO
	pivot_vector = lerp(pivot_vector, pivot_target, delta * pivot_speed)

func update_offset_vector(delta) -> void:
	offset_vector = lerp(offset_vector, offset_target, delta * offset_speed)

func follow_target(delta) -> void:
	if target:
		target_position = target.global_position
	target_position += pivot_vector * get_max_pivot_length() # add pivot
	target_position += offset_vector # add offset
	global_position = lerp(global_position, target_position, delta * move_speed)

func get_max_pivot_length() -> float:
	var view_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	return pivot_amount * view_height / 2
