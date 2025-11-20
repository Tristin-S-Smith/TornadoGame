extends Node3D

@onready var beam_hb = $stand/cannon/Beam/Area3D

var active := false

var firing := false


func _ready() -> void:
	$AnimationPlayer.play("RESET")
	visible = false
	beam_hb.monitoring = true

func activate() -> void:
	active = true
	$AnimationPlayer.play("cannonReady")
	Global.music.start_final_sequence()


func _physics_process(delta: float) -> void:
	if firing and !Global.tornado.end_processed:
		if beam_hb.has_overlapping_bodies() or beam_hb.has_overlapping_areas():
			print("Beam hit something")
			Global.tornado.hit_by_lazer = true
			Global.tornado.determine_act_after_lazer()
		await get_tree().create_timer(0.1).timeout
		if Global.tornado and !Global.tornado.end_processed:
			Global.tornado.determine_act_after_lazer()

func fire() -> void:
	print("fired_beam")
	firing = true
	
