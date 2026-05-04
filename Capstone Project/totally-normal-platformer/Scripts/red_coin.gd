extends RigidBody2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var red_coin_counter: Label = $"../../CanvasLayer/MarginContainer/VBoxContainer/red_coin_counter"
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "RopeArea":
		audio_stream_player_2.play()
		await $AudioStreamPlayer2.finished
		Global.red_coin += 1 
		queue_free()
		print("red coin: " + str(Global.red_coin))
		red_coin_counter.text = "Red Coins: " + str(Global.red_coin) + "/10"

	if Global.red_coin == 10:
		Global.red_met = true
		if Global.coin_met == true and Global.red_met == true:
			get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
