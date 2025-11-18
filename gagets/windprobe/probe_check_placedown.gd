extends Node3D

var can_be_placed : bool = false

@onready var actual = preload("res://gagets/windprobe/wind_probe.tscn")

func _physics_process(delta: float) -> void:
	can_be_placed = false if $Area.has_overlapping_bodies() else true
	
	if can_be_placed:
		#$probe/Cube_001.get_surface_override_material(0).albedo_color = Color.GREEN
		$probe/Cube_001.material_override.albedo_color = Color.GREEN
	else:
		#$probe/Cube_001.get_surface_override_material(0).albedo_color = Color.RED
		$probe/Cube_001.material_override.albedo_color = Color.RED

func place() -> void:
	var probe = actual.instantiate()
	get_tree().get_root().add_child(probe)
	probe.global_position = global_position
