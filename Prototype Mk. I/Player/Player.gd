extends KinematicBody2D

"""
IT 6034 Game Development - Game Project
March 2022

Milestone 1 is to get the player ship to move correctly. Using the up and down keys
is fine, but following the mouse with a small delay is more natural shooter behaviour.
Im happy with the behaviour as at 16/03/2022

The idea behind tractor_range is to have an area around the ship, and upon another area 
entering it, activate a tween to that node to move it to the ship, like a tractor beam
"""


#gets the tween node to work with, as long as the script is ready
onready var TweenNode = get_node("Tween")
onready var powerup_timer = get_node("Power_Timer")
export (float ) var laser_speed = 1400
#set the pixelated laser offset so it doesnt spawn in the ship

#preload the laser for firing
var Laser = preload("res://Weapons/Laser.tscn")
#set the speed at which the laser moves, exported to editor.
var laser_offset = Vector2(45, 0)
#set a boosted timer describing the length we have an extra power for

#set a recharge timer so that the bullets cant spawn each frame
var powered_recharge_rate = 0.05 #rate when powered up
var recharge_rate = 0.25 #standard fire rate
var recharge_timer = 0.25
#initialise health - each time the player hits an asteroid, reduce health by 1
var player_health = 3
#score
var score = 0


# a variable to see if a player is under the effect of a power up (or down!)
var is_powered_up = false


func _ready():
	pass#set_process(true)
	
#function used when applying effects to player
func apply_power_up():
	powerup_timer.start(2)
	while powerup_timer.time_left > 0:
		recharge_rate = 0.1

#function for applying damage to the ship
func damage_ship():
	#add animation, sound etc code for damage here
	#...
	#reduce the player health 
	player_health -=1
	#make the damage sprite visible
	#hard coded for demo
	if player_health == 2:
		var damagesprite = get_node("Damage 1")
		damagesprite.visible = true;
	if player_health == 1:
		var damagesprite = get_node("Damage 2")
		damagesprite.visible = true;
	#if damage reaches 0, destroy ship.
	if player_health <=0:
		destroy_ship()

#function for destroying the ship
func destroy_ship():
	#apply animation and sounds here
	print("Ship destroyed, game over")
	#remove the ship
	#self.queue_free()
	#pause for a moment
	var game_over_label = get_parent().get_node("Game_Over_Label")
	game_over_label.visible = true
	get_tree().paused = true
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().paused = false
	#changes scene to main menu
	get_tree().change_scene("res://Screens/MainScreen.tscn")
	
	
	
#code for firing - takes an argument that changes fire rate based on powerups.
func shoot(delta, power: bool):

	if recharge_timer <= 0:
		#create a new instance of the laser
		var laser = Laser.instance()
		#make the position the same as the player, but offset.
		laser.position = position + laser_offset
		laser.projectile_speed += laser_speed
		get_parent().add_child(laser)
		#reset recharge timer
		if power == true: #powered up fire rate
			recharge_timer = powered_recharge_rate
		else: # standard fire rate.
			recharge_timer = recharge_rate
	else:
		recharge_timer -= delta
	
#code dealing with ship movement on screen
func move():
	#The tween gets the mouse position and moves towards it smoothly.
	var mouse_pos = get_global_mouse_position()
	TweenNode.interpolate_property(self, "position", position, mouse_pos, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT)
	TweenNode.start()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move()
	#check if player is powered up
	if is_powered_up:
		#start the timer for 2 seconds worth of boosted fire
		powerup_timer.start(2)	
		print ("timer started")
		is_powered_up = false
	#if the timer has any remaining time, and the player clicks, fire in boosted mode

	if Input.is_mouse_button_pressed(BUTTON_LEFT):
			if powerup_timer.time_left > 0:
				shoot(delta, true)
			else:
				shoot(delta, false)

func _on_Power_Timer_timeout():
	powerup_timer.stop()
	#is_powered_up = false
	print ("timed out")
