@tool
extends Path2D

signal path_end_reached(value)

@export var path_width : int = 4:
	set(val): path_width = val; queue_redraw()
@export var bubble_scene : PackedScene
@export var bubble_travel_time : float = 0.9

var pool_idx : int = 0
var pool : Array[PathFollow2D] = []
var pool_size : int = 20
var min_animation_gap : float = bubble_travel_time / pool_size * 1.1
var animation_gap_timer : SceneTreeTimer = null
var buildup : int = 0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	populate_pool()

func populate_pool() -> void:
	for i in pool_size:
		var f = add_follower()
		f.ready.connect(attach_bubble.bind(f))
		pool.append(f)

func _draw() -> void:
	if curve:
		var point_array = curve.get_baked_points()
		if point_array.size() >= 2:
			draw_polyline(point_array, Color.WHITE, path_width)

func add_follower() -> PathFollow2D:
	# CREATE FOLLOWER
	var follower = PathFollow2D.new()
	call_deferred("add_child", follower)
	return follower

func attach_bubble(follower : PathFollow2D) -> void:
	var bubble = bubble_scene.instantiate()
	follower.call_deferred("add_child", bubble)

func animate_follower() -> void:
	if within_animation_gap():
		buildup += 1
		return
	var follower = pool[pool_idx]
	if follower_can_animate(follower):
		var value = 1 + buildup
		var max_scale_increase : float = 1.0
		var buildup_scale = Vector2.ONE * min(0.1 * buildup, max_scale_increase)
		follower.scale = Vector2.ONE + buildup_scale
		tween_follower(follower).finished.connect(_on_follower_tween_finished.bind(follower, value))
		cycle_pool_idx()
		reset_animation_gap_timer()
		buildup = 0

func follower_can_animate(follower : PathFollow2D) -> bool:
	return follower.progress_ratio == 1.0 or follower.progress_ratio == 0

func tween_follower(follower : PathFollow2D) -> Tween:
	follower.show()
	follower.progress_ratio = 0.0
	var t = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	t.tween_property(follower, "progress_ratio", 1.0, bubble_travel_time)
	return t

func reset_animation_gap_timer() -> void:
	animation_gap_timer = get_tree().create_timer(min_animation_gap)

func within_animation_gap() -> bool:
	return animation_gap_timer and animation_gap_timer.time_left > 0

func cycle_pool_idx() -> void:
	pool_idx = get_next_pool_idx()

func get_next_pool_idx() -> int:
	return wrapi(pool_idx + 1, 0, pool_size)

func _on_follower_tween_finished(follower : PathFollow2D, value : int) -> void:
	follower.hide()
	path_end_reached.emit(value)
