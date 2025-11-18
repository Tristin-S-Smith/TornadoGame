extends Node2D

@onready var probe: Node3D = $"../.."


func _draw() -> void:
	if !probe.mapped_dist : return
	if !probe.can_track_tornado: return
	draw_arc(probe.mapped_coords, probe.mapped_dist, 0, 360, 50, Color.BLUE, 1, true)
	#pass

func _process(delta: float) -> void:
	queue_redraw()
