extends Node

signal currency_changed(currency)

const base_currency = 20

var currency : int = base_currency :
	set(val): currency = val; currency_changed.emit(currency)
