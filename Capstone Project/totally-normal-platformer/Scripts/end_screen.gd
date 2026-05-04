extends Control
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "Great Job!\nYou collected\n67 coins and 10 red coins with\n" + str(Global.life) + " deaths!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/Home.tscn")
