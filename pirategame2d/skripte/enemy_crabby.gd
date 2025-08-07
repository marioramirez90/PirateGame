extends CharacterBody2D

@export var enemySpeed = 100.0
@export var enemyHP = 3
@export var enemyDamage = 1

const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0

var playerInDamageZone = false
var enemyDirection = 1
var isDead = false

func _ready() -> void:
	checkStatus()

func run():
	$AnimatedSprite2D.play("run")

func _physics_process(delta):
	if !isDead:
		# gravity
		if !is_on_floor():
			velocity.y += GRAVITY * delta
		else:
			velocity.y = 0

		# wall flip
		if is_on_wall():
			if enemyDirection == -1:
				enemyDirection = 1
				$AnimatedSprite2D.flip_h = true
			else:
				enemyDirection = -1
				$AnimatedSprite2D.flip_h = false

		# movement
		velocity.x = enemyDirection * enemySpeed
		move_and_slide()

func attack():
	if !isDead:
		enemyDirection = 0
		await get_tree().create_timer(0.4).timeout
		if playerInDamageZone and !isDead:
			$AnimatedSprite2D.play("attack")
			await get_tree().create_timer(0.2).timeout
			Global.playerDamage(enemyDamage)
			enemyDirection = 1
		else:
			enemyDirection = 1

		checkStatus()

func checkStatus():
	if enemyHP <= 0:
		isDead = true
		enemyDirection = 0
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("dead")
		await get_tree().create_timer(5).timeout
		queue_free()
	else:
		if playerInDamageZone:
			attack()
		else:
			run()

func _on_animated_sprite_2d_animation_finished() -> void:
	if !isDead:
		checkStatus()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !isDead and area.is_in_group("FromPlayer"):
		enemyHP -= 1
		enemyDirection = 0
		$AnimatedSprite2D.play("hit")
		await get_tree().create_timer(1).timeout
		enemyDirection = 1
		checkStatus()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !isDead and body.is_in_group("player"):
		playerInDamageZone = true
		checkStatus()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if !isDead and body.is_in_group("player"):
		playerInDamageZone = false
		checkStatus()
