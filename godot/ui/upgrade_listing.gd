@tool
class_name AttributeListing
extends MarginContainer

@onready var buy_button: Button = %BuyButton
@onready var title_label: Label = %TitleLabel
@onready var detail_label: Label = %DetailLabel
@onready var cost_label: Label = %CostLabel
@onready var rank_meter: GridContainer = %RankMeter

var single_use : bool = false
var attribute : String = "" : 
	set(val): attribute = val; match_attribute_data()


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	buy_button.pressed.connect(_on_buy_button_pressed)
	GameManager.currency_changed.connect(refresh_disabled_state.unbind(1))
	AttributeManager.attribute_updated.connect(_on_attribute_updated)

func match_attribute_data() -> void:
	var data : AttributeData = AttributeManager.find_attribute_data(attribute)
	if data:
		title_label.text = data.title
		#detail_label.text = data.details
		detail_label.text = data.get_details_with_references()
		cost_label.text = str(data.upgrade_cost) + "p"
		rank_meter.rank = data.rank
		# Disable purchase if not affordable
		buy_button.disabled = GameManager.currency < data.upgrade_cost
		single_use = data.single_use

func refresh_disabled_state() -> void:
	var data : AttributeData = AttributeManager.find_attribute_data(attribute)
	buy_button.disabled = GameManager.currency < data.upgrade_cost

func _on_buy_button_pressed() -> void:
	AttributeManager.attempt_upgrade(attribute)
	match_attribute_data()
	# Hide single use upgrades
	if single_use and rank_meter.rank >= 1:
		hide()

func _on_attribute_updated(attribute_name: String, _attribute_value: float) -> void:
	if attribute_name != attribute_name:
		return
	match_attribute_data()
