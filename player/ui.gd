extends CanvasLayer

@onready var car_entry_beam: RayCast3D = $"../Cam/Camera3D/CarEntryBeam"

var looking_at_car_entry : bool = false


func _physics_process(delta: float) -> void:
	visible = not Global.map.visible
	$Label2.text = str(Engine.get_frames_per_second())
	if car_entry_beam.is_colliding():
		if car_entry_beam.get_collider().is_in_group("carEnterTrigger"):
			$Label.visible = true
			looking_at_car_entry = true
		else:
			$Label.visible = false
			looking_at_car_entry = false
	else:
		$Label.visible = false
		looking_at_car_entry = false
