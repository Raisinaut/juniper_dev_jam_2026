extends Node2D

@onready var wheel: Wheel = %Wheel
@onready var paddle: Node2D = %Paddle
@onready var bubble_path: Path2D = %BubblePath
@onready var hamster_spawner: RadialSpawner = %HamsterSpawner
@onready var currency_counter: Counter = %Currency
@onready var pellet_rate: Counter = %PelletRate
@onready var bubbles: CPUParticles2D = %Bubbles
@onready var shaky_camera: ShakyCamera = %ShakyCamera
@onready var screen_border: Area2D = %ScreenBorder

func _ready() -> void:
	update_pellet_rate()
	hamster_spawner.global_position = wheel.global_position
	hamster_spawner.radius = wheel.inner_radius()
	# Connect Signals
	currency_counter.value = GameManager.currency
	wheel.rpm_changed.connect(_on_wheel_rpm_changed)
	wheel.clicked.connect(_on_wheel_clicked)
	wheel.tick_passed.connect(paddle.flick)
	paddle.flicked.connect(bubble_path.send_value)
	bubble_path.path_end_reached.connect(_on_bubble_path_animation_finished)
	AttributeManager.attribute_updated.connect(_on_attribute_updated)
	GameManager.currency_changed.connect(_on_game_manager_currency_changed)

func update_wheel_rpm() -> void:
	var hamster_count = AttributeManager.get_attribute_value("hamster_count")
	var hamster_rpm = AttributeManager.get_attribute_value("hamster_rpm")
	hamster_spawner.active_count = round(hamster_count)
	wheel.rpm = hamster_spawner.active_count * hamster_rpm

func _on_bubble_path_animation_finished(value : int) -> void:
	GameManager.currency += value

func _on_attribute_updated(attribute: String, value: float) -> void:
	match(attribute):
		"hamster_count", "hamster_rpm":
			update_wheel_rpm()
		"paddle_count":
			wheel.tick_count = round(value)

func _on_wheel_rpm_changed(value : float) -> void:
	GameManager.current_rpm = value
	update_pellet_rate()

# This is kinda broken. Find a better way to track earned pellets
func update_pellet_rate() -> void:
	var wheel_generation = (GameManager.current_rpm * wheel.tick_count) / 60
	var hamster_count = AttributeManager.get_attribute_value("hamster_count")
	var lazer_eyes = AttributeManager.get_attribute_value("lazer_eyes")
	var hamster_generation = hamster_count * (lazer_eyes * 50) / 1.5
	var sum = wheel_generation + hamster_generation
	pellet_rate.value = sum
	bubbles.speed_scale = clamp(sum / 50, 0.1, 1.5)
	bubbles.modulate = lerp(Color(.2,.2,.2,.5), Color.GOLD, min(1, bubbles.speed_scale))

func _on_wheel_clicked() -> void:
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property($ClickPrompt, "modulate:a", 0, 0.4)

func _on_game_manager_currency_changed(value : int) -> void:
	currency_counter.set_value(value)
