extends VehicleBody3D

const MAX_STEER = 0.7
@onready var main_cam: Camera3D = $carBase/CamHold/Camera3D
@onready var cam_hold: Node3D = $carBase/CamHold
@onready var anims: AnimationPlayer = $AnimationPlayer
const POWER = 125

var engine_inside_vol = -50
var engine_outside_vol = -25

var player_in_car = false

var parked := true
var can_park := true

@onready var steering_wheel: Node3D = $steeringWheel

@onready var player = preload("res://player/player.tscn")

enum Gears {
	DRIVE, REVERSE, NEUTRAL, BREAK
}

var current_gear = Gears.BREAK

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.car = self
	Global.car_cam = main_cam
	#Engine.time_scale = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_car:
		Global.curr_player_location = global_position
		var axis = Input.get_axis("right", "left")
		steering = move_toward(steering, axis * MAX_STEER, 2 * delta)
		steering_wheel.rotation.x = lerp_angle(steering_wheel.rotation.x, axis * -0.8, 2 * delta)
		
		var eng_axis = Input.get_axis("backward", "forward")
		
		if parked:
			current_gear = Gears.BREAK
		elif eng_axis > 0:
			current_gear = Gears.DRIVE
		elif eng_axis < 0:
			current_gear = Gears.REVERSE
		else:
			current_gear = Gears.NEUTRAL
		
		engine_force = eng_axis * POWER if !parked else 0
		
		if parked:
			brake = 1
			#linear_velocity = Vector3.ZERO
		else:
			brake = 0
		
		if Input.is_action_just_pressed("park") and can_park:
			$CarPark.play()
			if parked:
				parked = false
			else:
				parked = true
		
		if Input.is_action_just_pressed("interact") and parked:
			exit_car()
	else:
		steering = move_toward(steering, 0 * MAX_STEER, 2 * delta)
		steering_wheel.rotation.x = lerp_angle(steering_wheel.rotation.x, 0 * -0.8, 2 * delta)
	
	if current_gear == Gears.DRIVE or current_gear == Gears.REVERSE:
		$EngineDrive.volume_db = lerp($EngineDrive.volume_db, -3.0, 5*delta)
	else:
		$EngineDrive.volume_db = lerp($EngineDrive.volume_db, -60.0, 5*delta)

func _physics_process(delta: float) -> void:
	move_cam_to_hold(delta)

func enter_car() -> void:
	if main_cam.current : return
	
	main_cam.global_position = Global.player_cam.global_position
	main_cam.global_rotation = Global.player_cam.global_rotation
	main_cam.current = true
	Global.player.queue_free()
	anims.play("EnterCar")
	await anims.animation_finished
	player_in_car = true

func exit_car() -> void:
	player_in_car = false
	
	engine_force = 0
	#brake = 99999
	linear_velocity = Vector3.ZERO
	spawn_player()
	anims.play("ExitCar")
	await anims.animation_finished
	mod_player_camera()
	Global.player_cam.current = true
	anims.play("RESET")


func move_cam_to_hold(delta : float) -> void:
	main_cam.position.x = lerp(main_cam.position.x, 0.0, 5 * delta)
	main_cam.position.y = lerp(main_cam.position.y, 0.0, 5 * delta)
	main_cam.position.z = lerp(main_cam.position.z, 0.0, 5 * delta)
	
	main_cam.rotation.x = lerp(main_cam.rotation.x, 0.0, 5 * delta)
	main_cam.rotation.y = lerp(main_cam.rotation.y, 0.0, 5 * delta)
	main_cam.rotation.z = lerp(main_cam.rotation.z, 0.0, 5 * delta)
	

func spawn_player() -> void:
	await get_tree().create_timer(0.3).timeout
	var p = player.instantiate()
	get_tree().get_root().add_child(p)
	p.main_cam.current = false
	p.global_position = $PlayerSpawn.global_position
	p.global_rotation.y = main_cam.global_rotation.y
	p.main_cam.global_position = main_cam.global_position
	p.main_cam.global_rotation = main_cam.global_rotation

func mod_player_camera() -> void:
	Global.player.main_cam.global_position = main_cam.global_position
	Global.player.global_rotation = main_cam.global_rotation
	#await get_tree().create_timer(1.0).timeout
	#Global.player.global_rotation.x = 0
	#Global.player.global_rotation.z = 0
	

func door_closed():
	$Engine.volume_db = engine_inside_vol
	Global.player_in_car = true

func door_open():
	$Engine.volume_db = engine_outside_vol
	Global.player_in_car = false
