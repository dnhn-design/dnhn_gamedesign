extends CharacterBody2D

@export var speed = 400
@export var max_rope_length = 300.0
@export var snap_force = 1000.0 
var was_at_limit = false

var snap_cooldown = 0.0  # Timer to prevent infinite loops

@onready var main_node = get_parent()


func _physics_process(delta):
	# 1. Active Player check
	if main_node.active_player != self:
		return 

	# 2. Handle Cooldown (Count down every frame)
	if snap_cooldown > 0:
		snap_cooldown -= delta
		move_and_slide() # Allow the snap movement to finish
		return # EXIT HERE so we don't calculate rope limits during a snap

	var other_player = main_node.get_other_player(self)
	var dist = position.distance_to(other_player.position)
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# 3. Rope Limit Logic
	var at_limit = dist >= max_rope_length - 5.0
	
	# 4. Trigger Snap-Back
	# If we WERE at limit and now keys are released
	if was_at_limit and direction == Vector2.ZERO:
		apply_snap_back(other_player)
		was_at_limit = false
		snap_cooldown = 0.5 # Ignore rope logic for 0.5 seconds
		return

	# 5. Prevent Drifting (The Hard Clamp)
	var target_velocity = direction * speed
	
	if dist > max_rope_length:
		var dir_to_anchor = (other_player.position - position).normalized()
		# If trying to move further away, kill velocity and lock position
		if direction.dot(dir_to_anchor) < 0:
			target_velocity = Vector2.ZERO
			# This line physically resets you to the edge of the circle
			position = other_player.position - (dir_to_anchor * max_rope_length)

	velocity = target_velocity
	move_and_slide()
	
	was_at_limit = at_limit


func apply_snap_back(anchor):
	# 1. Calculate the direction TOWARD the anchor (to release tension)
	var dir_to_anchor = (anchor.position - position).normalized()
	
	# 2. How far to snap back (keep this small, like 30-50 pixels)
	var snap_distance = 50.0 
	
	# 3. Reset velocity so we don't "drift" after the snap
	velocity = Vector2.ZERO
	
	# 4. Smooth Snap animation
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	
	# ONLY move the active player (self). The anchor stays immobile.
	var target_pos = position + (dir_to_anchor * snap_distance)
	tween.tween_property(self, "position", target_pos, 0.15)
