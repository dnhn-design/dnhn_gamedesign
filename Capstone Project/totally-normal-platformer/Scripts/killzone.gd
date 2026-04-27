extends Area2D
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("you died.")
	Global.coin = 0
	print("coin reset")
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Global.life += 1
	print("Life: " + str(Global.life))
