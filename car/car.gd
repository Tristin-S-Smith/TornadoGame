extends VehicleBody3D

const MAX_STEER = 0.8
@onready var main_cam: Camera3D = $carBase/CamHold/Camera3D
@onready var cam_hold: Node3D = $carBase/CamHold
@onready var anims: AnimationPlayer = $AnimationPlayer
const POWER = 125

var engine_inside_vol = -50
var engine_outside_vol = -20

var player_in_car = false

@onready var steering_wheel: Node3D = $steeringWheel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.car = self
	Global.car_cam = main_cam
	#Engine.time_scale = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_car:
		var axis = Input.get_axis("right", "left")
		steering = move_toward(steering, axis * MAX_STEER, 2 * delta)
		steering_wheel.rotation.x = lerp_angle(steering_wheel.rotation.x, axis * -0.8, 2 * delta)
		
		engine_force = Input.get_axis("backward", "forward") * POWER

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
	

func move_cam_to_hold(delta : float) -> void:
	main_cam.position.x = lerp(main_cam.position.x, 0.0, 5 * delta)
	main_cam.position.y = lerp(main_cam.position.y, 0.0, 5 * delta)
	main_cam.position.z = lerp(main_cam.position.z, 0.0, 5 * delta)
	
	main_cam.rotation.x = lerp(main_cam.rotation.x, 0.0, 5 * delta)
	main_cam.rotation.y = lerp(main_cam.rotation.y, 0.0, 5 * delta)
	main_cam.rotation.z = lerp(main_cam.rotation.z, 0.0, 5 * delta)
	
	
func door_closed():
	$Engine.volume_db = engine_inside_vol
