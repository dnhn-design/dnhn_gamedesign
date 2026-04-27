extends Area2D
@onready var coin_counter: Label = $"../../CanvasLayer/MarginContainer/Coin_counter"


func _on_body_entered(body: Node2D) -> void:
	Global.coin += 1
	print("Coin: " + str(Global.coin))
	Global.coin += 1
	coin_counter.text = "Coins: " + str(Global.coin) + " /50"
	queue_free()
	
	if Global.coin == 50:
		get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
