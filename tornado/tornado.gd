extends CharacterBody3D


const SPEED = 0.2

#const SPEED = 1

const JUMP_VELOCITY = 4.5

var hit_by_lazer := false

var end_processed := false

var can_move = true



func _ready() -> void:
	Global.tornado = self
	global_position.x = randi_range(-1600, -1200)
	global_position.z = randi_range(-1600, -1200)

func _physics_process(delta: float) -> void:
	
	if can_move:
		global_position.x = move_toward(global_position.x, Global.city_marker.global_position.x, SPEED)
		global_position.z = move_toward(global_position.z, Global.city_marker.global_position.z, SPEED)
	
	Global.tornado_location = global_position
	
	if Global.player_in_car:
		$Sound.volume_db = 0
	else:
		$Sound.volume_db = 5

func determine_act_after_lazer(make_sound : bool = true) -> void:
	Global.map.end_cutscene = true
	can_move = false
	end_processed = true
	if make_sound:
		$AudioStreamPlayer/AudioCut.play("lazerSound")
	await get_tree().create_timer(0.1).timeout
	$CanvasLayer/ColorRect2.visible = true
	$CanvasLayer/ColorRect3.visible = true
	Global.car.queue_free()
	if Global.player:
		Global.player.queue_free()
	if hit_by_lazer:
		$Result.play("Die")
	else:
		Global.music.fail_stop()
		$Sound.volume_db = 10
		$Result.play("Miss")
		
