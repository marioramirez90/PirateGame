extends Node

var redDiamond = 0
var goldCoins = 0


func debugShowValues():
	print("RED DIAMONDS:" + str(redDiamond) +"Gold: " +str(goldCoins))

func addRedDiamond():
	redDiamond += 1
	debugShowValues()
	
func removeRedDiamond():
	redDiamond -= 1
	debugShowValues()

func addGoldCoin():
	goldCoins += 1
	debugShowValues()

func removeGoldCoin():
	goldCoins -= 1
	debugShowValues()
# Called when the node enters the scene tree for the first time.
