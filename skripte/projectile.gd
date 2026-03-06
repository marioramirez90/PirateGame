extends Node2D


var directionLeft = true
var pSpeed = 5
var damage = 1

var canMove = true
var range = 1000
var startX = 0

var lookLeft = true

var projectileType = Global.projectileTypes.CANNON


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startX = self.position.x
	
	if(lookLeft == false):
		$AnimatedSprite2D.flip_h = true
	
	if(projectileType == 0):
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("idle_wood")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(canMove):
		if(directionLeft):
			self.position.x -= pSpeed
			if( startX - self.position.x > range):
				canMove = false
				explode()
		else:
			self.position.x += pSpeed
			if(self.position.x - startX > range):
				canMove = false
				explode()

func explode():
	if(projectileType == 0):
		$AnimatedSprite2D.play("explosion")
	else:
		$AnimatedSprite2D.play("explosion_wood")
	await get_tree().create_timer(0.3).timeout
	queue_free()
	
#hit player
func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		canMove = false
		Global.playerDamage(damage)
		explode()
		
		
