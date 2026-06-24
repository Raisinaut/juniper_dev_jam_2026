@tool
class_name AttributeListing
extends MarginContainer

@onready var buy_button: Button = %BuyButton
@onready var title_label: Label = %TitleLabel
@onready var detail_label: Label = %DetailLabel
@onready var cost_label: Label = %CostLabel
@onready var rank_meter: GridContainer = %RankMeter

var attribute : String = "" : 
	set(val): attribute = val; match_attribute_data()


func _ready() -> void:
	buy_button.pressed.connect(_on_buy_button_pressed)
	GameManager.currency_changed.connect(refresh_disabled_state.unbind(1))

func match_attribute_data() -> void:
	var data : AttributeData = AttributeManager.find_attribute(attribute)
	if data:
		title_label.text = data.title
		detail_label.text = data.details
		cost_label.text = str(data.upgrade_cost)
		rank_meter.rank = data.rank
		# Disable purchase if not affordable
		buy_button.disabled = GameManager.currency < data.upgrade_cost

func refresh_disabled_state() -> void:
	var data : AttributeData = AttributeManager.find_attribute(attribute)
	buy_button.disabled = GameManager.currency < data.upgrade_cost

func _on_buy_button_pressed() -> void:
	AttributeManager.attempt_upgrade(attribute)
	match_attribute_data()
