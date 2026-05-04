extends CharacterBody2D
@onready var jump_sfx: AudioStreamPlayer = $"../jump_sfx"


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var active_p1: ColorRect = $ColorRect
@onready var partner: CharacterBody2D = $"../chicken_p2"
var max_dist = 100.0
var dist_to_partner = 0

func _process(_delta):
	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")


func _physics_process(delta: float) -> void:
	# 1. Apply Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Global.p1_active:
		# 2. Get intended movement
		var direction := Input.get_axis("left", "right")
		var target_velocity = direction * SPEED
		
		# 3. THE TETHER CHECK (Horizontal Only)
		if partner:
			var x_dist = global_position.x - partner.global_position.x
			
			# Are we at the max distance?
			if abs(x_dist) >= max_dist:
				# Check if the player is trying to move FURTHER away
				# (e.g. on the right side and moving right, OR on the left side and moving left)
				if (x_dist > 0 and target_velocity > 0) or (x_dist < 0 and target_velocity < 0):
					target_velocity = 0 # Block the movement away
		
		# 4. Assign velocity and Move
		velocity.x = target_velocity
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_sfx.play()
			
		move_and_slide()
	else:
		velocity.x = 0
		move_and_slide() 

#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	#if Global.p1_active:
		#if Input.is_action_just_pressed("jump") and is_on_floor():
			#velocity.y = JUMP_VELOCITY
			#
		#var direction := Input.get_axis("left", "right")
		#velocity.x = direction * SPEED
		#move_and_slide()
#
	#if partner:
		## Calculate how far away we are on just the X axis
		#var x_diff = global_position.x - partner.global_position.x
		#
		## If we exceed the max distance horizontally
		#if abs(x_diff) > max_dist:
			## Snap X to the limit, but KEEP our current Y (no floating!)
			#var spawn_side = sign(x_diff) # 1 if right, -1 if left
			#global_position.x = partner.global_position.x + (spawn_side * max_dist)
			#velocity.x = 0
	#move_and_slide()
