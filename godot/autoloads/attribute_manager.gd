extends Node

signal attribute_updated(attribute_name: String, attribute_value: float)

@export var attribute_folder : String = "res://resources/attributes/"
@export var upgrade_folder : String = "res://resources/upgrades/"

var attributes : Dictionary[String, float] = {}
var upgrades : Array[AttributeData] = []

func _ready() -> void:
	populate_attributes()

func populate_attributes() -> void:
	for a in load_folder_resources(attribute_folder):
		if a is AttributeData: 
			upgrades.append(a)
			attributes[a.attribute] = a.base_value
			attribute_updated.emit(attributes[a.attribute])

func attempt_upgrade(a : String) -> void:
	var data = find_attribute_data(a)
	var cost = data.upgrade_cost
	var upgraded_value = data.upgrade_value(attributes[a])
	if GameManager.currency >= cost:
		attributes[a] = upgraded_value
		attribute_updated.emit(a, upgraded_value)
		GameManager.currency -= cost

func find_attribute_data(_attribute : String) -> AttributeData:
	for a in upgrades:
		if a.attribute == _attribute:
			return a
	return null

func get_attribute_value(attribute: String) -> float:
	if attributes.has(attribute):
		return attributes[attribute]
	push_warning("No attribute found named ", attribute)
	return 0


# FILE ACCESS ------------------------------------------------------------------
func load_folder_resources(folder_path : String) -> Array:
	var dir := DirAccess.open(folder_path)
	var contents := []
	if dir: 
		dir.list_dir_begin()
		for file: String in dir.get_files():
			file = file.trim_suffix(".remap") # for export builds
			var resource := load(dir.get_current_dir() + "/" + file)
			contents.append(resource)
	else:
		printerr("Could not open folder")
	return contents
