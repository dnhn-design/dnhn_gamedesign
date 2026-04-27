extends Area2D

@onready var label: Label = $"../../LABEL"


func _on_body_entered(body: Node2D) -> void:
	label.show()
