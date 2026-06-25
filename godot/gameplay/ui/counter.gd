@tool
class_name Counter
extends PanelContainer

@export var title : String = "" : set = set_title
@export var value : float = 0.0 : set = set_value
@export var hide_decimal : bool = true
@export var label_settings : LabelSettings : set = set_label_settings

func set_title(val) -> void:
	title = val
	%TitleLabel.text = title

func set_value(val) -> void:
	value = val
	if hide_decimal:
		val = int(round(val))
	%ValueLabel.text = str(val).pad_decimals(1)

func set_label_settings(val) -> void:
	label_settings = val
	%TitleLabel.label_settings = label_settings
	%ValueLabel.label_settings = label_settings
