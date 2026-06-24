extends Node2D

const MIN_SPEED = 0.0
const MAX_SPEED = 2.0

@onready var character_animator: AnimationPlayer = $CharacterAnimator

@export var speed_curve : Curve

var run_speed : float = 0:
	set(val):
		run_speed = val
		character_animator.speed_scale = run_speed

func _ready() -> void:
	update_speed()
	GameManager.current_rpm_changed.connect(update_speed.unbind(1))

func update_speed() -> void:
	var max_rpm = 120
	var rpm_scale = inverse_lerp(0, max_rpm, GameManager.current_rpm)
	run_speed = speed_curve.sample(rpm_scale)
