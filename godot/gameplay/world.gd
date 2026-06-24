extends Node2D

@onready var wheel: Wheel = %Wheel
@onready var paddle: Node2D = %Paddle
@onready var bubble_path: Path2D = %BubblePath
@onready var hamster_spawner: RadialSpawner = %HamsterSpawner
@onready var currency_counter: Counter = %Currency
@onready var pellet_rate: Counter = %PelletRate

func _ready() -> void:
	wheel.tick_passed.connect(paddle.flick.unbind(1))
	wheel.tick_passed.connect(bubble_path.send_value)
	wheel.clicked.connect(_on_wheel_clicked)
	bubble_path.path_end_reached.connect(_on_bubble_path_animation_finished)
	hamster_spawner.global_position = wheel.global_position
	hamster_spawner.radius = wheel.inner_radius()
	AttributeManager.attribute_updated.connect(_on_attribute_updated)
	wheel.rpm_changed.connect(_on_wheel_rpm_changed)
	GameManager.currency_changed.connect(_on_game_manager_currency_changed)

func _on_bubble_path_animation_finished(value : int) -> void:
	GameManager.currency += value

func _on_attribute_updated(data : AttributeData) -> void:
	match(data.attribute):
		"hamster_count":
			var rpm_per_hamster = 15
			hamster_spawner.active_count = round(data.current_value)
			wheel.rpm = hamster_spawner.active_count * rpm_per_hamster
		"paddle_count":
			wheel.tick_count = round(data.current_value)

func _on_wheel_rpm_changed(value : float) -> void:
	GameManager.current_rpm = value
	pellet_rate.value = (value * wheel.tick_count) / 60

func _on_wheel_clicked() -> void:
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property($ClickPrompt, "modulate:a", 0, 0.4)

func _on_game_manager_currency_changed(value : int) -> void:
	currency_counter.set_value(value)
