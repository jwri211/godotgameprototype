extends RigidBody2D

onready var viewport = get_viewport().get_visible_rect()

#set the direction to follow the x axis to the right
var direction := Vector2(1, 0)
# set the projectile speed - zero to start, player ship and powerups manipulate this
var projectile_speed := 0

func _ready():
	add_to_group("shots") # add to firegroup for identification

#method for removing unseen bullets from queue
func clean_up():
	if not viewport.has_point(position):
		self.queue_free()

#each frame move in the set direction at set speed
func _process(delta: float) -> void:
	#set the speed and position
	self.position += direction * projectile_speed * delta
	clean_up()

#when the laser enters another body, remove it
func _on_Laser_body_entered(body):
	self.queue_free()
