class_name AttributeData
extends Resource


@export var title : String = ""
@export var details : String = ""
@export var attribute : String = ""

@export_category("Value")
@export var base_value : float = 0.0 :
	set(val): base_value = val; current_value = base_value
@export var upgrade_increment : float = 0
@export var upgrade_funnction : UpgradeFunction

@export_category("Cost")
@export_range(0, 1, 1, "or_greater") var base_cost : int = 0 :
	set(val): base_cost = val; upgrade_cost = base_cost
@export_range(1.0, 5.0, 0.01, "or_greater") var cost_increase_exponent : float = 1.0

# These must be initialized via setter functions to respect export values
var current_value : float
var upgrade_cost : int

enum UpgradeFunction {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

func upgrade() -> void:
	match(upgrade_funnction):
		UpgradeFunction.ADD:
			current_value += + upgrade_increment
		UpgradeFunction.SUBTRACT:
			current_value -= upgrade_increment
		UpgradeFunction.MULTIPLY:
			current_value *= upgrade_increment
		UpgradeFunction.DIVIDE:
			current_value /= upgrade_increment
	scale_upgrade_cost()

func scale_upgrade_cost() -> void:
	upgrade_cost = round(pow(upgrade_cost, cost_increase_exponent))
