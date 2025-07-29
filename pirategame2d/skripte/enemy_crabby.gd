extends CharacterBody2D

@export
var enemySpeed = 100.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var enemyDirection = 1

func _ready() -> void:
	checkStatus()

func run():
	$AnimatedSprite2D.play("run")

func _physics_process(delta: float) -> void:
	if is_on_wall():
		if(enemyDirection == -1):
			enemyDirection = 1
			$AnimatedSprite2D.flip_h = true
		else :
			enemyDirection = -1
			$AnimatedSprite2D.flip_h = false
		
	velocity.x = enemyDirection * enemySpeed
	move_and_slide()

func checkStatus():
	run()


func _on_animated_sprite_2d_animation_finished() -> void:
	checkStatus()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
