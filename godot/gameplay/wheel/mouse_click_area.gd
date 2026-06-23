@tool
extends Area2D

signal mouse_clicked

@onready var collision_shape = $CollisionShape2D

var mouse_over : bool = false

func set_shape_radius(value : float) -> void:
	$CollisionShape2D.shape.radius = value

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and mouse_over:
		if event.pressed and not event.is_echo():
			mouse_clicked.emit()

func _on_mouse_entered() -> void:
	mouse_over = true
	
func _on_mouse_exited() -> void:
	mouse_over = false
