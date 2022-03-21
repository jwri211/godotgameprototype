extends "res://Loot/Loot.gd"

func _ready():
	#stops from spawning other loot as well.
	is_powerup = true

func _on_Power_Down_body_entered(body):
		#toggle power up on (start timer) 
#	player.is_powered_up = true;
#	#apply th powerup effect - in this case, fire rate slows down
#	#with a cap at a 0.05 fire rate.
#	if player.recharge_rate < 0.5:
#		player.recharge_rate += 0.05
#	#complete rest of above parents method.
#	._on_Loot_body_entered(body)
	pass

#func _on_Power_Down_area_entered(area):
#	collecting = true #tells the parent scrip to start moving the tween.
