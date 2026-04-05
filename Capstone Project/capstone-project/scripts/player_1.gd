extends CharacterBody2D

# --- Variables ---
@export var speed = 300.0
@export var jump_velocity = -550.0
@export var max_rope_length = 300.0

# Get gravity from project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Tracking state
var was_at_limit = false
var snap_cooldown = 0.0

# Reference to the main/level node (Update this path to match your scene)
@onready var main_node = get_parent() 

func _physics_process(delta):
	# 1. ALWAYS Apply Gravity (Both Active and Anchor fall)
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Handle Snap Cooldown (Ignore limits briefly after a snap)
	if snap_cooldown > 0:
		snap_cooldown -= delta
		move_and_slide()
		return

	# 3. Get the other player for distance calculations
	var other_player = main_node.get_other_player(self)
	var dist = position.distance_to(other_player.position)
	
	# 4. Check if this character is the one being controlled
	if main_node.active_player == self:
		handle_active_movement(delta, other_player, dist)
	else:
		handle_anchor_state()

	# 5. Final physics execution
	move_and_slide()

func handle_active_movement(delta, other_player, dist):
	var direction = Input.get_axis("ui_left", "ui_right")
	var at_limit = dist >= max_rope_length - 5.0
	
	# SNAP-BACK TRIGGER: If we were pulling the rope and let go
	if was_at_limit and direction == 0:
		apply_snap_back(other_player)
		was_at_limit = false
		return

	# JUMPING
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# HORIZONTAL MOVEMENT & TETHER LIMIT
	var target_vel_x = direction * speed
	
	if dist >= max_rope_length:
		var dir_to_anchor = (other_player.position - position).normalized()
		# If trying to move AWAY from the anchor while at max distance
		if (direction > 0 and dir_to_anchor.x < 0) or (direction < 0 and dir_to_anchor.x > 0):
			target_vel_x = 0
			# Hard Clamp: Keep position exactly at the rope limit
			position = other_player.position - (dir_to_anchor * max_rope_length)

	velocity.x = target_vel_x
	was_at_limit = at_limit

func handle_anchor_state():
	# The Anchor cannot move horizontally, but keeps their vertical gravity velocity
	velocity.x = 0

func apply_snap_back(anchor):
	var dir_to_anchor = (anchor.position - position).normalized()
	var snap_distance = 40.0 # How far they "sproing" back
	
	velocity = Vector2.ZERO # Kill momentum
	snap_cooldown = 0.2    # Briefly pause tether logic
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	
	# Move the active player TOWARD the anchor
	var target_pos = position + (dir_to_anchor * snap_distance)
	tween.tween_property(self, "position", target_pos, 0.15)
