extends Node2D
@onready var p1: CharacterBody2D = $Player
@onready var p2: CharacterBody2D = $chicken_p2
@onready var string: Line2D = $Line2D

var was_at_limit = false
var active_color = Color(0.765, 0.0, 0.361, 1.0)
var inactive_color = Color(0.3, 0.3, 0.3, 1)
var active_player

var line_normal_color = Color(1, 1, 1, 1)
var line_max_color = Color(0.765, 0.0, 0.361, 1.0)

func _ready():
	active_player = p1 
	update_player_visuals()

func _process(_delta):
	# Update the line visual
	string.points = PackedVector2Array([p1.position - Vector2(0,5), p2.position - Vector2(0,5)])
	
	# Swap
	if Input.is_action_just_pressed("swap"):
		Global.p1_active = !Global.p1_active
		Global.p2_active = !Global.p2_active
		
		if active_player == p1:
			active_player = p2
		else:
			active_player = p1
	
	# Keep the line updated
	string.points = PackedVector2Array([p1.position - Vector2(0,5), p2.position - Vector2(0,5)])
	
	# Calculate distance
	var dist = p1.position.distance_to(p2.position)
	var max_len = 100 
	
	# Change color if we are at or near the limit
	if dist >= max_len - 10: # The '20' gives a bit of buffe
		string.default_color = line_max_color
	else:
		string.default_color = line_normal_color
	

	if dist >= max_len:
		pass
	
	update_player_visuals()


	
func update_player_visuals():
	var s1 = p1.get_node("ColorRect")
	var s2 = p2.get_node("ColorRect")
	
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
