extends Node2D

"""
This is the overall script for the level
Here, we want to constantly spawn asteroids to the right of the screen, these will 'fall'
towards the left, for the player to 'fly through'

"""

#grab the gui labels for updates
onready var scorelabel = null
onready var healthlabel = null

#when ready, gets the x and y values of the viewport for later use.
onready var viewport_x = get_viewport().size.x
onready var viewport_y = get_viewport().size.y

onready var player = null
#use for asteroid generation
var rng = RandomNumberGenerator.new()
#preload the asteroid scene for spawning in
var Asteroid = preload("res://Asteroids/Asteroid.tscn")

#set spawn timer for the asteroids to appear.
var respawn_timer = 0.3

func _ready():
	rng.randomize()
	player = get_node("Player")
	scorelabel = get_node("Score_Label")
	healthlabel = get_node("Health_Label")

#copied from the laser script for now
#designed to spawn an asteroid outside the screen each half second, 
#with random attributes of size, position an spin.
func spawn_asteroid(delta):
	if respawn_timer <= 0:
		#create a new instance of the asteroid
		var asteroid = Asteroid.instance()
		#== POSITIONAL PROPERTIES == 
		#spawn the asteroid just outside the range fo the viewport
		asteroid.position.x = rand_range(viewport_x+50, viewport_x +200)
		#randomise the vertical position of the asteroids.
		asteroid.position.y = rand_range(0, viewport_y)
		#== SIZE PROPERTIES==
		#randomise the scale, between half and 2.5 X normal scale
		var random_scale = rng.randf_range(0.65, 2)
		var scaled_vector = Vector2(random_scale, random_scale)
		#scale has to apply to all children
		for i in asteroid.get_children():
			i.scale = (scaled_vector)
		#== SPIN PROPERTIES ==
		var random_spin = rng.randf_range(-1,1)
		asteroid.asteroid_spin *= random_spin
		#add the asteroid to the scene
		add_child(asteroid)
		#reset recharge timer
		respawn_timer = 0.25
	#if timer not expired, count down by another tick
	else:
		respawn_timer -= delta
	
func _process(delta):
	spawn_asteroid(delta)
	#allows close on escape key
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	#update GUI
	if scorelabel != null and healthlabel !=  null:
		scorelabel.text = "Score: " + str(player.score)
		healthlabel.text = "Health: " + str(player.player_health)
	
