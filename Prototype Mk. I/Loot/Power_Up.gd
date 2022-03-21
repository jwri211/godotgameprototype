extends "res://Loot/Loot.gd"


func _ready():
	#stops from spawning other loot as well.
	is_powerup = true

#func _on_Power_Up_area_entered(area):
	#collecting = true #tells the parent scrip to start moving the tween.

func _on_Power_Up_body_entered(body):
	#toggle power up on (start timer) 
	player.is_powered_up = true;
	#apply th powerup effect - in this case, fire faster as more are collected
	#with a cap at a 0.03 fire rate.
#	if player.recharge_rate >= 0.1:
#		player.recharge_rate -= 0.05
	#complete rest of above parents method.
	#player.apply_power_up()
	._on_Loot_body_entered(body)

