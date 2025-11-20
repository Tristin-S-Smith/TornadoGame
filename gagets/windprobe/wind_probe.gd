extends Node3D

var distance_to_tornado : float
var mapped_coords : Vector2
var mapped_dist

var can_track_tornado := false

const MAX_DETECT_DIST : float = 900.0

func _ready() -> void:
	$InitialPlace.play()

func _physics_process(delta: float) -> void:
	
	$CanvasLayer.visible = Global.map.visible
	
	distance_to_tornado = global_position.distance_to(Global.tornado_location)
	mapped_dist = distance_to_tornado * (325.0/1500.0)
	
	mapped_coords = Global.map.convert_3d_to_map_coords(global_position)
	
	$CanvasLayer/Icon.position = mapped_coords
	
	can_track_tornado = true if distance_to_tornado < MAX_DETECT_DIST else false
