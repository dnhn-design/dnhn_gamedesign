extends CharacterBody2D


const SPEED = 90.0
var JUMP_VELOCITY = -200.0
@onready var active_p2: ColorRect = $ColorRect
@onready var partner: CharacterBody2D = $"../Player"
var max_dist = 100.0
var dist_to_partner = 0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Global.p2_active:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		var direction := Input.get_axis("left", "right")
		velocity.x = direction * SPEED

		#var direction := Input.get_axis("left", "right")
		#if direction:
			#velocity.x = direction * SPEED
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)

		if Input.is_action_pressed("down"):
			JUMP_VELOCITY = -130.0
			$AnimatedSprite2D.play("down_walk")
		if Input.is_action_pressed("up"):
			JUMP_VELOCITY = -200.0
			$AnimatedSprite2D.play("up")
			$AnimatedSprite2D.play("up_walk")
	else:
		velocity.x = 0
	
	if partner:
		# Calculate how far away we are on just the X axis
		var x_diff = global_position.x - partner.global_position.x
		
		# If we exceed the max distance horizontally
		if abs(x_diff) > max_dist:
			# Snap X to the limit, but KEEP our current Y (no floating!)
			var spawn_side = sign(x_diff) # 1 if right, -1 if left
			global_position.x = partner.global_position.x + (spawn_side * max_dist)
			# Reset horizontal velocity so we don't 'accelerate' into the wall
			velocity.x = 0
	
	move_and_slide()
	
var is_up = true
	
func _process(_delta):
	if Input.is_action_pressed("down"):
		is_up = false 
	elif Input.is_action_pressed("up"):
		is_up = true

	if is_up == true and Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("up_walk")
	
	if is_up == true and Input.is_action_pressed("right"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("up_walk")
	
	if is_up == false and Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("down")
		$AnimatedSprite2D.play("down_walk")

	if is_up == false and Input.is_action_pressed("right"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("down")
		$AnimatedSprite2D.play("down_walk")


func _on_animated_sprite_2d_frame_changed() -> void:
	var sprite = $AnimatedSprite2D
	var collider = $CollisionShape2D
	
	# Example: Change size for a "crouch" frame
	if sprite.animation == "down" or sprite.animation == "down_walk":
		$CollisionShape2D.shape.radius = 4.0
		$CollisionShape2D.shape.height = 14.0
	elif sprite.animation == "up" or sprite.animation == "up_walk":
		$CollisionShape2D.shape.radius = 7.0
		$CollisionShape2D.shape.height = 14.0
		
