class_name Bubble
extends PathFollow2D

const MAX_SCALE_INCREASE = 1.0
const SCALE_INCREMENT = 0.05

var value : int = 1 :
	set(val): 
		value = val
		var value_scale = Vector2.ONE * min(SCALE_INCREMENT * value, MAX_SCALE_INCREASE)
		scale = Vector2.ONE + value_scale
