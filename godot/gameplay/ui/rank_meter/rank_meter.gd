extends GridContainer

@export var marker : PackedScene = null
@export var marker_size := Vector2.ZERO

var rank : int = 0 :
	set(val): 
		var last_rank = rank
		rank = val
		visible = (rank > 0)
		if rank > last_rank:
			for i in rank - last_rank:
				add_marker()
		elif rank < last_rank:
			for i in last_rank - rank:
				get_child(-1).queue_free()

func _ready() -> void:
	var h_separation = get_theme_constant("h_separation")
	columns = floor(360 / (marker_size.x + h_separation)) # FIXME: base on actual width
	hide()

func add_marker() -> void:
	var inst : TextureRect = marker.instantiate()
	inst.custom_minimum_size = marker_size
	call_deferred("add_child", inst)

func remove_marker() -> void:
	get_child(-1).queue_free()
