extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animSprite = $AnimatedSprite2D

var hassSword = false

var isAttacking = false
var toggleAttack = false

func checkAttack():
	if Input.is_action_just_pressed("ui_attack"):
		isAttacking = true 
		$AttackArea/CollisionShape2D.disabled = false
		
		randomize()
		var randomAttack = randi_range(1,3)
		match(randomAttack):
			1: animSprite.play("attack1")
			2: animSprite.play("attack2")
			3: animSprite.play("attack3")
		
		
		
		if(animSprite.flip_h):
			$AttackArea/CollisionShape2D.position.x += -1
			toggleAttack = true




func _physics_process(delta):
	
	var swordExtra = "_nos"
	
	if(hassSword):
		swordExtra = "_hs"

	if(isAttacking == false):
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			print(velocity.y)
			
			if(velocity.y > 0):
				animSprite.play("fall" + swordExtra)
			else:
				animSprite.play("jump" + swordExtra)
		else:
			if(velocity.x == 0):
				animSprite.play("idle" + swordExtra)
			else:
				animSprite.play("run" + swordExtra)

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		# links rechts animation
			if(velocity.x < 0):
				animSprite.flip_h = true
			else:
				animSprite.flip_h = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if(hassSword):
			checkAttack()

	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	isAttacking = false
	$AttackArea/CollisionShape2D.disabled = true
	if(toggleAttack):
		$AttackArea/CollisionShape2D.position.x += -1
		toggleAttack =false
		
