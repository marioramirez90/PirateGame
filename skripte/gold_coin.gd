extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		Global.addGoldCoin()
		$AudioStreamPlayer2D.play(0.2)
		$AnimatedSprite2D.visible = false
		await get_tree().create_timer(0.5).timeout
		queue_free()
