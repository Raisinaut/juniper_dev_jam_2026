@tool
extends Path2D

signal path_end_reached(value)

@export var path_width : int = 4:
	set(val): path_width = val; queue_redraw()
@export var bubble_scene : PackedScene
@export var bubble_travel_time : float = 0.9

var pool_idx : int = 0
var pool : Array[PathFollow2D] = []
var pool_size : int = 30
var min_animation_gap : float = bubble_travel_time / pool_size * 1.1
var animation_gap_timer : SceneTreeTimer = null
var buildup : int = 0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	populate_pool()

func populate_pool() -> void:
	for i in pool_size:
		var b = add_bubble()
		pool.append(b)

func _draw() -> void:
	if curve:
		var point_array = curve.get_baked_points()
		if point_array.size() >= 2:
			draw_polyline(point_array, Color.WHITE, path_width)

func add_bubble() -> PathFollow2D:
	var bubble = bubble_scene.instantiate()
	call_deferred("add_child", bubble)
	return bubble

func send_value(value : int = 1) -> void:
	if within_animation_gap():
		buildup += value
		return
	var bubble = pool[pool_idx]
	if bubble_can_animate(bubble):
		bubble.value = value + buildup
		tween_bubble(bubble).finished.connect(_on_bubble_tween_finished.bind(bubble))
		cycle_pool_idx()
		reset_animation_gap_timer()
		buildup = 0

func bubble_can_animate(bubble : PathFollow2D) -> bool:
	return bubble.progress_ratio == 1.0 or bubble.progress_ratio == 0

func tween_bubble(bubble : PathFollow2D) -> Tween:
	bubble.show()
	bubble.progress_ratio = 0.0
	var t = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	t.tween_property(bubble, "progress_ratio", 1.0, bubble_travel_time)
	return t

func reset_animation_gap_timer() -> void:
	animation_gap_timer = get_tree().create_timer(min_animation_gap)

func within_animation_gap() -> bool:
	return animation_gap_timer and animation_gap_timer.time_left > 0

func cycle_pool_idx() -> void:
	pool_idx = get_next_pool_idx()

func get_next_pool_idx() -> int:
	return wrapi(pool_idx + 1, 0, pool_size)

func _on_bubble_tween_finished(bubble : PathFollow2D) -> void:
	bubble.hide()
	path_end_reached.emit(bubble.value)
