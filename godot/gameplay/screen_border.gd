extends Area2D

signal hits_depleted

var hits_remaining : int = 10

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body : PhysicsBody2D) -> void:
	hits_remaining -= 1
	body.impact()
	print(body)
	#if hits_remaining <= 0:
