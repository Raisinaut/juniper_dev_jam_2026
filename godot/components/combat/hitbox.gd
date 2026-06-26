class_name HitBox
extends Area2D

@warning_ignore("unused_signal")
signal detected(hurtbox) # not ideal, but signal is detected by the hurtbox class

@export var damage := 1
@export var knockback := 0

var disabled := false : set = set_disabled
var knockback_direction := Vector2.ZERO


func set_disabled(state):
	disabled = state
	set_deferred("monitorable", not disabled)

func get_collision_shape() -> CollisionShape2D:
	for c in get_children():
		if c is CollisionShape2D:
			return c
	return null
