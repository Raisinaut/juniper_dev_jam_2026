class_name AttributeData
extends Resource

@export var title : String = ""
@export var details : String = ""
## The script-definition name of the attribute
@export var attribute : String = ""
@export var single_use : bool = false
## Include a %s in details where these values should be referenced respectively
@export var referenced_attributes : Array[String] = []

@export_category("Value")
@export var base_value : float = 0.0
@export var upgrade_increment : float = 0
@export var upgrade_function : UpgradeFunction

@export_category("Cost")
@export_range(0, 1, 1, "or_greater") var base_cost : int = 0 :
	set(val): base_cost = val; upgrade_cost = base_cost
@export_range(1.0, 5.0, 0.01, "or_greater") var cost_increase_exponent : float = 1.0

## The number of upgrades this attribute has
var rank : int = 0
# Must be initialized via setter functions to respect export values
var upgrade_cost : int

enum UpgradeFunction {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

func upgrade_value(value : float) -> float:
	match(upgrade_function):
		UpgradeFunction.ADD:
			value += + upgrade_increment
		UpgradeFunction.SUBTRACT:
			value -= upgrade_increment
		UpgradeFunction.MULTIPLY:
			value *= upgrade_increment
		UpgradeFunction.DIVIDE:
			value /= upgrade_increment
	scale_upgrade_cost()
	rank += 1
	return value

func scale_upgrade_cost() -> void:
	upgrade_cost = round(pow(upgrade_cost, cost_increase_exponent))

func get_details_with_references() -> String:
	var referenced_attribute_values : Array[float] = []
	for a in referenced_attributes:
		if AttributeManager.attributes.has(a):
			referenced_attribute_values.append(AttributeManager.attributes[a])
		else:
			push_warning("No value found in reference to ", a)
	return details % referenced_attribute_values
