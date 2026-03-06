extends Node

var redDiamond = 2
var goldCoins = 0



enum projectileTypes {CANNON, TOTEM}

signal playerHit

func playerDamage(_value):
	playerHit.emit()
	redDiamond -= 1
	if(redDiamond <= 0):
		get_tree().change_scene_to_file("res://Levels/DeadLevel.tscn")
	else:
		playerHit.emit()

func debugShowValues():
	print("RED DIAMONDS:" + str(redDiamond) +"Gold: " +str(goldCoins))

func addRedDiamond():
	redDiamond += 1
	
	
func removeRedDiamond():
	redDiamond -= 1
	

func addGoldCoin():
	goldCoins += 1
	

func removeGoldCoin():
	goldCoins -= 1
	
# Called when the node enters the scene tree for the first time.
