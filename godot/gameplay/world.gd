extends Node2D

@onready var wheel: Wheel = %Wheel
@onready var paddle: Node2D = %Paddle
@onready var bubble_path: Path2D = %BubblePath

func _ready() -> void:
	wheel.tick_passed.connect(paddle.flick)
	wheel.tick_passed.connect(bubble_path.add_bubble)

#func _process(delta: float) -> void:
	#wheel.rotation_speed += delta * 0.1
