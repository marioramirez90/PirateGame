extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$VBoxContainer/HBoxContainer/RedDiamodsValue.text = str(Global.redDiamond)
	$VBoxContainer/HBoxContainer2/GoldCoinValue.text = str(Global.goldCoins)
