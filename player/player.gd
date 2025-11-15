extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var cam: Node3D = $Cam
@onready var ui: CanvasLayer = $Ui


@export var cam_speed : float = 5
@export var cam_rotation_amount : float = 1

@onready var item_hold: Node3D = $Cam/ItemHold
@export var sway_amm : float = 5
@export var rot_amm : float = 0.05

var mouse_input : Vector2
var def_pos : Vector3

func _input(event):
	if !cam : return
	if event is InputEventMouseMotion:
		cam.rotation.x -= event.relative.y * cam_speed
		cam.rotation.x = clamp(cam.rotation.x, -1.25, 1.5)
		self.rotation.y -= event.relative.x * cam_speed
		mouse_input = event.relative

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	def_pos = item_hold.position
	Global.player_cam = $Cam/Camera3D
	Global.player = self

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("interact") and ui.looking_at_car_entry:
		Global.car.enter_car()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	tilt(input_dir.x, delta)
	item_tilt(input_dir.x, delta)
	item_sway(delta)
	item_bob(delta)

func tilt(input_x, delta) -> void:
	cam.rotation.z = lerp(cam.rotation.z, -input_x * rot_amm, 8*delta)

func item_tilt(input_x, delta) -> void:
	item_hold.rotation.z = lerp(item_hold.rotation.z, -input_x * rot_amm, 8*delta)

func item_sway(delta) -> void:
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10 * delta)
	item_hold.rotation.x = lerp(item_hold.rotation.x, mouse_input.y * rot_amm * 0.05, 10 * delta)
	item_hold.rotation.y = lerp(item_hold.rotation.y, mouse_input.x * rot_amm * 0.05, 10 * delta)

func item_bob(delta) -> void:
	if velocity.length_squared() > 0:
		var amm := 0.01
		var freq := 0.01
		item_hold.position.y = lerp(item_hold.position.y, def_pos.y + sin(Time.get_ticks_msec() * freq) * amm, 10 * delta)
		item_hold.position.x = lerp(item_hold.position.x, def_pos.x + sin(Time.get_ticks_msec() * freq * 0.5) * amm, 10 * delta)
	else:
		item_hold.position.y = lerp(item_hold.position.y, def_pos.y, 10 * delta)
		item_hold.position.x = lerp(item_hold.position.x, def_pos.x, 10 * delta)
