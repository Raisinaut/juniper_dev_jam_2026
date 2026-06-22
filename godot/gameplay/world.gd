extends Node2D

@onready var wheel: Wheel = %Wheel
@onready var paddle: Node2D = %Paddle
@onready var bubble_path: Path2D = %BubblePath
@onready var hamster: Node2D = %Hamster

func _ready() -> void:
	wheel.tick_passed.connect(paddle.flick.unbind(1))
	wheel.tick_passed.connect(bubble_path.send_value)
	bubble_path.path_end_reached.connect(_on_bubble_path_animation_finished)
	wheel.rpm_changed.connect(_on_wheel_rpm_changed)

func _on_bubble_path_animation_finished(value : int) -> void:
	GameManager.currency += value

#func _process(_delta: float) -> void:
	#UpgradeManager.upgrade_attribute("wheel_rpm", UpgradeManager.FunctionType.ADD)

func _on_wheel_rpm_changed(rpm : float) -> void:
	var normal_rpm = 45
	var rpm_scale = rpm / normal_rpm
	hamster.run_speed = rpm_scale
