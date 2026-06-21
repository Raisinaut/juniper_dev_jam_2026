extends PanelContainer

@onready var label: Label = %Label
@onready var value: Label = %Value

func set_value(val : int) -> void:
	value.text = str(val)

func _ready() -> void:
	GameManager.currency_changed.connect(_on_game_manager_currency_changed)
	set_value(GameManager.currency)

func _on_game_manager_currency_changed(val : int) -> void:
	set_value(val)
