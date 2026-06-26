class_name VariableTimer
extends Timer

@export var base_duration : float = 1.0
@export var duration_variation : float = 0.0


func _ready() -> void:
	if autostart:
		start_varied()

func start_varied() -> void:
	var variation : float = randf_range(-duration_variation, duration_variation)
	start(base_duration + variation)
