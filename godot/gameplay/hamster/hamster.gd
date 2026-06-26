class_name Hamster
extends Node2D

const MIN_SPEED = 0.0
const MAX_SPEED = 2.0

@onready var character_animator: AnimationPlayer = $CharacterAnimator
@onready var lazer_emitter: Emitter = %LazerEmitter
@onready var lazer_timer: VariableTimer = %LazerTimer
@onready var eye_animator: AnimationPlayer = %EyeAnimator

@export var speed_curve : Curve

var can_use_lazers : bool = false : set = set_can_use_lazers
var run_speed : float = 0 : set = set_run_speed


func _ready() -> void:
	update_speed()
	# Connect signals
	lazer_timer.timeout.connect(_on_lazer_timer_timeout)
	can_use_lazers = AttributeManager.get_attribute_value("lazer_eyes")
	GameManager.current_rpm_changed.connect(update_speed.unbind(1))
	AttributeManager.attribute_updated.connect(_on_attribute_changed)

func update_speed() -> void:
	var max_rpm = 120
	var rpm_scale = inverse_lerp(0, max_rpm, GameManager.current_rpm)
	run_speed = speed_curve.sample(rpm_scale)

func _on_attribute_changed(attribute_name: String, value : float) -> void:
	if attribute_name == "lazer_eyes":
		can_use_lazers = bool(round(value))


# LAZERS -----------------------------------------------------------------------
func fire_lazer() -> void:
	eye_animator.play("activate")
	await eye_animator.animation_finished
	var dir = Vector2.from_angle(randf_range(0, 2 * PI))
	var all_targets = get_tree().get_nodes_in_group("lazer_targets")
	if !all_targets.is_empty():
		var target = all_targets[0]
		dir = lazer_emitter.global_position.direction_to(target.global_position)
	lazer_emitter.emit(dir, self)

func _on_lazer_timer_timeout() -> void:
	fire_lazer()


# SETTERS ----------------------------------------------------------------------
func set_can_use_lazers(val) -> void:
	can_use_lazers = val
	if can_use_lazers:
		lazer_timer.start_varied()
	else:
		lazer_timer.stop()

func set_run_speed(val) -> void:
	run_speed = val
	character_animator.speed_scale = run_speed
