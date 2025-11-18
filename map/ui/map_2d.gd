extends CanvasLayer

@onready var map_center: Vector2 = $MapCenter.global_position

func _ready() -> void:
	Global.map = self
	visible = false

func convert_3d_to_map_coords(input : Vector3) -> Vector2:
	var result_x := map_center.x + input.x * (325.0/1500.0)
	var result_y :=  map_center.x + input.z * (325.0/1500.0)
	return Vector2(result_x, result_y)


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Map"):
		visible = not visible
	
	if not visible:
		return
	
	
	var car_mapped_coords = convert_3d_to_map_coords(Global.car.global_position)
	$CarIcon.global_position = car_mapped_coords
	
	if Global.player:
		$PlayerIcon.visible = true
		var player_mapped_coords = convert_3d_to_map_coords(Global.player.global_position)
		$PlayerIcon.global_position = player_mapped_coords
	else:
		$PlayerIcon.visible = false
