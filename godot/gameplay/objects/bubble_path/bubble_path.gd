@tool
extends Path2D

signal path_end_reached

@export var path_width : float = 4:
	set(val): path_width = val; queue_redraw()
@export var bubble_scene : PackedScene

func _draw() -> void:
	var point_array = curve.get_baked_points()
	draw_polyline(point_array, Color.WHITE, path_width)

func add_bubble() -> void:
	# CREATE FOLLOWER
	var follower = PathFollow2D.new()
	call_deferred("add_child", follower)
	await follower.ready
	# ADD BUBBLE TO FOLLOWER
	var bubble = bubble_scene.instantiate()
	follower.call_deferred("add_child", bubble)
	# TWEEN FOLLOWER DOWN PATH
	var t = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	t.tween_property(follower, "progress_ratio", 1.0, 1.8)
	# CONNECT SIGNAL TO HANDLE TWEEN COMPLETION
	t.finished.connect(_on_follower_tween_finished.bind(follower))

func _on_follower_tween_finished(follower : PathFollow2D) -> void:
	follower.queue_free()
	path_end_reached.emit()
