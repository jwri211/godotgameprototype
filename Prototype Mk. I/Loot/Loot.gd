extends Area2D

"""
Code for the loot. When the players collection area overlaps loot, a tween should move the loot
to the player (like a tractor beam) and then inrcrement score.
"""

onready var player = get_parent().get_node("Player")
onready var TweenNode = get_node("Tween")

var collecting = false
var is_powerup = false
#
#func ready():
#	#add the loot to the loot group for identification purposes.
#	add_to_group("loot") 

#when colliding with player, disapear (simulates collection)
func _on_Loot_body_entered(body):
	#increment score
	if not is_powerup:
		player.score +=1
	#print (player.score)
	queue_free()
	
func move_to_ship():
	#tween to player ship
	#get the position of the player ship
	var player_pos = player.position
	TweenNode.interpolate_property(self, "position", position, player_pos, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	TweenNode.start()	
	
#method that activate movement when the loot enters the range of the tractor beam.
#if any other area enters this area (i.e, the tractor range!)
func _on_Loot_area_entered(area):
	collecting = true #start the moving tween
	
#done this way so it doesnt move to only the position the ship was at when it entered 
#tractor zone range.
func _physics_process(delta):
	position.x -=10
	#checks if the loot is being collected,
	if collecting == true:
		#if so, move towards ship
		move_to_ship()
