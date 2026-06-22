extends Node2D

@onready var character_animator: AnimationPlayer = $CharacterAnimator

var run_speed : float = 0:
	set(val):
		run_speed = val
		character_animator.speed_scale = run_speed
