extends Node3D

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	visible = false
