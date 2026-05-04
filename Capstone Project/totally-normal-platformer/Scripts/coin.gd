extends Area2D
@onready var coin_counter: Label = $"../../CanvasLayer/MarginContainer/Coin_counter"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_body_entered(body: Node2D) -> void:
	Global.coin += 1
	audio_stream_player.play()
	print("Coin: " + str(Global.coin))
	Global.coin += 1
	coin_counter.text = "Coins: " + str(Global.coin) + " /67"
	await $AudioStreamPlayer.finished
	queue_free()
	
	if Global.coin == 67:
		get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
