extends Node

signal currency_changed(currency)
signal current_rpm_changed(rpm)

const base_currency = 100

var currency : int = base_currency :
	set(val): currency = val; currency_changed.emit(currency)
var current_rpm : float = 0 :
	set(val): current_rpm = val; current_rpm_changed.emit(current_rpm)
