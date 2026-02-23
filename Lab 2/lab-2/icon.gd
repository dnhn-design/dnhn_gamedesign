extends Sprite2D

@export var speed = 10
@export var robot_name = ""
@export var robot_age = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("10")
	print(position.x)
	print("Hello World!")
	print("My name is " + robot_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	#4-directional movement
	if Input.is_action_pressed("ui_up"):
		position.y -= speed
		rotation_degrees += 5
	elif Input.is_action_pressed("ui_down"):
		position.y += speed
		rotation_degrees -= 5
	elif Input.is_action_pressed("ui_left"):
		position.x -= speed
		rotation_degrees -= 5
	elif Input.is_action_pressed("ui_right"):
		position.x += speed
		rotation_degrees += 5
	
	#8-directional movement (diagonal too)
	if Input.is_action_pressed("ui_up") && Input.is_action_pressed("ui_right"):
		position.x += speed/2
		position.y -= speed/2
	elif Input.is_action_pressed("ui_up") && Input.is_action_pressed("ui_left"):
		position.y -= speed/2
		position.x -= speed/2
	elif Input.is_action_pressed("ui_down") && Input.is_action_pressed("ui_right"):
		position.y += speed/2
		position.x += speed/2
	elif Input.is_action_pressed("ui_down") && Input.is_action_pressed("ui_left"):
		position.y += speed/2
		position.x -= speed/2

#func _input(event: InputEvent) -> void:
	#print(event)
