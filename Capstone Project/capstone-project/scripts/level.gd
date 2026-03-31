extends Node2D

@onready var p1 = $"Player 1"
@onready var p2 = $"Player 2"
@onready var string: Line2D = $String



var active_color = Color(0.203, 0.289, 1.0, 1.0)      # Normal/Bright
var inactive_color = Color(0.3, 0.3, 0.3, 1) # Dark/Greyed out
var active_player # This tracks who is currently moving

var line_normal_color = Color(1, 1, 1, 1) # White or your default color
var line_max_color = Color(1, 0, 0, 1)    # Bright Red for tension


func _ready():
	active_player = p1 
	update_player_visuals()

func _process(_delta):
	# Update the rubber band visual
	string.points = PackedVector2Array([p1.position, p2.position])
	
	# Handle the Swap
	if Input.is_action_just_pressed("swap"):
		if active_player == p1:
			active_player = p2
		else:
			active_player = p1
	
	# Keep the line updated
	string.points = PackedVector2Array([p1.position, p2.position])
	
	# Calculate distance
	var dist = p1.position.distance_to(p2.position)
	var max_len = 300 # Match this to your player script's max_dist
	
	# Change color if we are at or near the limit
	if dist >= max_len - 20: # The '20' gives a bit of buffer for strecthing
		string.default_color = line_max_color
	else:
		string.default_color = line_normal_color

	
	update_player_visuals()
			
func update_player_visuals():
	# Find the Sprite2D nodes inside your players
	# Using get_node("Sprite2D") ensures we target the image, not the whole body
	var s1 = p1.get_node("Sprite2D")
	var s2 = p2.get_node("Sprite2D")
	
	if active_player == p1:
		s1.modulate = active_color
		s2.modulate = inactive_color
	else:
		s1.modulate = inactive_color
		s2.modulate = active_color

# Helper function for the player scripts to find their partner
func get_other_player(current):
	if current == p1: return p2
	return p1
