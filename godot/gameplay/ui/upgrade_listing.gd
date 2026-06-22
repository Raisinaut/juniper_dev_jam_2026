@tool
extends MarginContainer

@onready var buy_button: Button = %BuyButton
@onready var title_label: Label = %TitleLabel
@onready var detail_label: Label = %DetailLabel
@onready var cost_label: Label = %CostLabel

@export var title : String = "" :
	set(val): title = val; %TitleLabel.text = val
@export var details : String = "" :
	set(val): details = val; %DetailLabel.text = val
@export var cost : int = 100 :
	set(val): cost = val; %CostLabel.text = str(val)
@export var linked_attribute : String = ""
@export var upgrade_function : UpgradeManager.FunctionType

func _ready() -> void:
	buy_button.pressed.connect(_on_buy_button_pressed)

func _on_buy_button_pressed() -> void:
	if GameManager.currency >= cost:
		UpgradeManager.upgrade_attribute(linked_attribute, upgrade_function)
		GameManager.currency -= cost
