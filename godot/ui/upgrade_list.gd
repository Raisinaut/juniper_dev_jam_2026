extends PanelContainer

@export var listing_scene : PackedScene = null

@onready var list_container: VBoxContainer = %ListContainer

func _ready() -> void:
	clear_list()
	populate_list()

func populate_list() -> void:
	for a in AttributeManager.upgrades:
		add_listing(a.attribute)

func clear_list() -> void:
	for l in list_container.get_children():
		l.queue_free()

func add_listing(attribute: String) -> void:
	var l : AttributeListing = listing_scene.instantiate()
	list_container.call_deferred("add_child", l)
	await l.ready
	l.attribute = attribute
