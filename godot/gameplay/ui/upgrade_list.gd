extends PanelContainer

@export var listing_scene : PackedScene = null

@onready var list_container: VBoxContainer = %ListContainer

func _ready() -> void:
	populate_list()

func populate_list() -> void:
	for a in AttributeManager.upgrades:
		add_listing(a.attribute)

func add_listing(attribute: String) -> void:
	var l : AttributeListing = listing_scene.instantiate()
	list_container.call_deferred("add_child", l)
	await l.ready
	l.attribute = attribute
