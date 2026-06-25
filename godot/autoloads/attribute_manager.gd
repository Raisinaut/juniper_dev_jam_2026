extends Node

signal attribute_updated(data : AttributeData)

@export var attribute_folder : String = "res://resources/attributes/"
var attributes : Array[AttributeData] = []

func _ready() -> void:
	populate_attributes()

func populate_attributes() -> void:
	for a in load_folder_resources(attribute_folder):
		if a is AttributeData: 
			attributes.append(a)

func attempt_upgrade(a : String) -> void:
	var data = find_attribute(a)
	var cost = data.upgrade_cost
	if GameManager.currency >= cost:
		data.upgrade()
		attribute_updated.emit(data)
		GameManager.currency -= cost

func find_attribute(_attribute : String) -> AttributeData:
	for a in attributes:
		if _attribute == a.attribute:
			return a
	return null


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
