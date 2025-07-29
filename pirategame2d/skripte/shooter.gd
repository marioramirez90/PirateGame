extends Node2D

@export var minWaitTime = 2
@export var maxWaitTime = 5
@export var lookLeft = true
@export var damageValue = 1
@export var pSpped = 5
@export var range = 1000
@export var projectilType = Global.projectileTypes.CANNON
@export var showFireEffect = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	
	if(lookLeft == false):
		$AnimatedSprite2D.flip_h =true
		$FireEfect.position.x *= -1
		$FireEfect.flip_h = true
	while(true):
		randomize()
		var waitTimer = randi_range(minWaitTime,maxWaitTime)
		await get_tree().create_timer(waitTimer).timeout
		fire()
		
	
func fire():
	$AnimatedSprite2D.play("fire")
	await get_tree().create_timer(0.2).timeout
	if(showFireEffect == true):
		$FireEfect.visible = true
		$FireEfect.play("fireeffect")
	
	spawnProjectile()
	await get_tree().create_timer(0.3).timeout
	$FireEfect.visible = false
	$AnimatedSprite2D.play("idle")
	
func spawnProjectile():
	var p = preload("res://Actors/Projectile.tscn").instantiate()
	p.pSpeed= pSpped
	p.damage = damageValue
	p.range = range
	p.projectileType = projectilType
	p.lookLeft = lookLeft
	
	if(lookLeft == false):
		p.directionLeft = false
	
	p.position = self.position
	get_parent().add_child(p)
	
