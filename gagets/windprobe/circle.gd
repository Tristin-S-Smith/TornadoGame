extends Node2D

@onready var probe: Node3D = $"../.."


func _draw() -> void:
	draw_arc(probe.mapped_coords, probe.mapped_dist, 0, 360, 50, Color.BLUE, 1, true)

func _process(delta: float) -> void:
	queue_redraw()
