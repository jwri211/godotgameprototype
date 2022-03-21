extends RigidBody2D

"""
Script for the asteroids. For now, we just want to remove them from the queue when
they leave the left hand bounds of the screen, we will be constantly spawning them 
to the right
"""
# preloads a loot scene for dropping
var Loot = preload("res://Loot/Loot.tscn")
var Powerup = preload("res://Loot/Power_Up.tscn")
var PowerDown = preload("res://Loot/Power_Down.tscn")

var rng = RandomNumberGenerator.new()

#each asteroid takes 3 hits to destroy
export (int) var hitpoints = 3 

var asteroid_spin = 3000
#calle when node ready in tree.
func _ready():
	pass

#checks if out of hitpoints, removes when @ 0
func check_destroyed():
	if hitpoints <=0:
		#play explosion animation # sound later here
		#...'
		$BreakSoundEffect.play()
		#chance to drop power up instead of star
		var powerup_chance = rand_range(0, 10)
		if powerup_chance > 5: 
			var new_power = Powerup.instance()
			new_power.position = position
			get_parent().add_child(new_power)
			self.queue_free()
#		elif powerup_chance > 8:
#			var new_power = PowerDown.instance()
#			new_power.position = position
#			get_parent().add_child(new_power)
#			self.queue_free()
		else:
			#instance a new normal loot node
			var new_loot = Loot.instance()
			new_loot.position = position # drop the loot at the position of the asteroid
			get_parent().add_child(new_loot) #add node to scene
			#dissapear mysteriously
			self.queue_free()
	
#remove hitpoints
func takes_damage():
	#play damage sounds, apply damage visuals, particles etc.
	hitpoints -=1

#performs this function each frame
func _process(_delta):
	check_destroyed()
	#check the asteroid has left the screen
	if position.x < -25:
		self.queue_free()

#performs this function when an asteroid is hit by something.
func _on_Asteroid_body_entered(body):
	#hit by laser
	if body.is_in_group("shots"):
		takes_damage()
		body.queue_free()
	#hit by ship	
	if body.get_name() == "Player":
		body.damage_ship()

#applied to the physics (generating spin only at the moment)
func _integrate_forces(state):
	set_applied_torque(asteroid_spin)
	
