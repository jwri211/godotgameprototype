extends ParallaxLayer

export (float) var BACKGROUND_SPEED = -10

func _process(delta) -> void:
	self.motion_offset.x += BACKGROUND_SPEED

