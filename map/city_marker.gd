extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position.x = 1000 + randi_range(-100, 100)
	global_position.z = 1000 + randi_range(-100, 100)
	Global.city_marker = self

func _physics_process(delta: float) -> void:
	if get_child(0).has_overlapping_bodies() and !Global.tornado.end_processed:
		Global.tornado.determine_act_after_lazer(false)
