class_name Projectile
extends CharacterBody2D

@export var speed : float = 0
@export var power : float = 0

@onready var sprite_trail: SpriteTrail = $SpriteTrail
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var impacted : bool = false :
	set(val): impacted = val; sprite.visible = not impacted


func _ready() -> void:
	sprite_trail.emptied.connect(_on_sprite_trail_emptied)
	top_level = true

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(get_movement_vector() * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("flick"):
			collider.flick(power)
		impact()

func get_movement_vector() -> Vector2:
	var direction := Vector2.from_angle(rotation)
	return direction * speed

func impact() -> void:
	impacted = true
	sprite_trail.emitting = false
	collision_shape.set_deferred("disabled", true)

func _on_sprite_trail_emptied() -> void:
	if impacted:
		queue_free()
