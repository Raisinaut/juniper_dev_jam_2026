extends Node

signal currency_changed(currency)
signal current_rpm_changed(rpm)

const base_currency : int = 0

var currency : int = base_currency :
	set(val): currency = val; currency_changed.emit(currency)
var current_rpm : float = 0 :
	set(val): current_rpm = val; current_rpm_changed.emit(current_rpm)


func can_afford(value : int) -> bool:
	return currency >= value

func _input(_event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if Input.is_action_just_pressed("cheat_money"):
		currency += 1000
