extends Node

signal attribute_updated(attribute : String, value : float)

## Stored by attribute name that corresponds to [br]
## an array containing the default value and upgrade increment
var attributes : Dictionary = {
	"wheel_rpm" : [0.0, 5]
}

enum FunctionType {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

func upgrade_attribute(attribute : String, type : FunctionType) -> void:
	var starting_value = get_attribute_value(attribute)
	var end_value = starting_value
	var upgrade_increment_value = get_attribute_upgrade_increment(attribute)
	match(type):
		FunctionType.ADD:
			end_value = starting_value + upgrade_increment_value
		FunctionType.SUBTRACT:
			end_value = starting_value - upgrade_increment_value
		FunctionType.MULTIPLY:
			end_value = starting_value * upgrade_increment_value
		FunctionType.DIVIDE:
			end_value = starting_value / upgrade_increment_value
	set_attribute_value(attribute, end_value)

func set_attribute_value(attribute : String, value : float) -> void:
	attributes[attribute][0] = value
	attribute_updated.emit(attribute, value)

func get_attribute_value(attribute : String) -> float:
	print(attributes)
	return attributes[attribute][0]

func get_attribute_upgrade_increment(attribute : String) -> float:
	return attributes[attribute][1]
