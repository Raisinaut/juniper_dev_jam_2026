class_name SwingPivot
extends Node2D

@onready var visualizer : Sprite2D = $Visualizer

var max_angle = PI / 4
var swing_tween : Tween

func _ready() -> void:
	# delete visualizer
	visualizer.queue_free()
	# Randomize initial rotation
	rotation = get_random_angle()
	new_swing()

func new_swing() -> void:
	stop_swing()
	# Pause
	#var pause_duration : float = randf_range(0.1, 0.2)
	#await get_tree().create_timer(pause_duration).timeout
	# Animate
	swing_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var a = get_random_angle()
	var d = randf_range(1.0, 2.0)
	swing_tween.tween_property(self, "rotation", a, d)
	swing_tween.finished.connect(new_swing)
	
	
func stop_swing() -> void:
	if swing_tween: swing_tween.kill()

func get_random_angle() -> float:
	return randf_range(-max_angle, max_angle)
