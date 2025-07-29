extends Node

var redDiamond = 0
var goldCoins = 0

enum projectileTypes {CANNON, TOTEM}

func playerDamage(value):
	print("player Hit: " + str(value))

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
