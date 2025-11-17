extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	Global.tornado = self

func _physics_process(delta: float) -> void:
	Global.tornado_location = global_position
	
	if Global.player_in_car:
		$Sound.volume_db = 0
	else:
		$Sound.volume_db = 5
	
	

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
