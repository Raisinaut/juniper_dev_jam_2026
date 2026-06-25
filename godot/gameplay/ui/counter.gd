@tool
class_name Counter
extends PanelContainer

@export var title : String = "" : set = set_title
@export var value : float = 0.0 : set = set_value
@export var hide_decimal : bool = true
@export var label_settings : LabelSettings : set = set_label_settings
@export var update_cooldown : float = 0.1

var update_cooldown_timer : SceneTreeTimer = null

func set_title(val) -> void:
	title = val
	%TitleLabel.text = title

func set_value(val) -> void:
	value = val
	if not update_cooldown_active():
		if hide_decimal:
			val = int(round(val))
		%ValueLabel.text = str(val).pad_decimals(1)
		if not Engine.is_editor_hint():
			start_update_cooldown()

func set_label_settings(val) -> void:
	label_settings = val
	%TitleLabel.label_settings = label_settings
	%ValueLabel.label_settings = label_settings

func start_update_cooldown() -> void:
	if update_cooldown > 0:
		update_cooldown_timer = get_tree().create_timer(update_cooldown, false)

func update_cooldown_active() -> bool:
	return update_cooldown_timer and update_cooldown_timer.time_left > 0
