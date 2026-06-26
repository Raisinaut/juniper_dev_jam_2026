extends StaticBody2D

signal flicked(power)

@onready var sprite: Sprite2D = $Sprite
@onready var collision: CollisionShape2D = $CollisionShape2D

var max_flick_rotation = 0.4
var min_flick_rotation = 0.2
var max_power = 30
var big_hits_before_break : int = 50 : set = set_big_hits_before_break
var broken : bool = false

var rotation_tween : Tween = null

func flick(power : float) -> void:
	if broken:
		return
	sprite.rotation = 0
	var r = remap(power, 0, max_power, min_flick_rotation, max_flick_rotation)
	if rotation_tween: rotation_tween.kill()
	rotation_tween = create_tween()
	rotation_tween.tween_property(self, "rotation", -r, 0.05)
	rotation_tween.tween_property(self, "rotation",  r * 0.5, 0.05)
	rotation_tween.tween_property(self, "rotation", -r * 0.2, 0.07)
	rotation_tween.tween_property(self, "rotation", 0, 0.05)
	flicked.emit(power)
	if power >= 20:
		big_hits_before_break -= 1

func set_big_hits_before_break(val) -> void:
	big_hits_before_break = val
	if val <= 0:
		broken = true
		animate_break()

func animate_break() -> void:
	collision.set_deferred("disabled", true)
	$AnimationPlayer.play("break")
	await $AnimationPlayer.animation_finished
	queue_free()
