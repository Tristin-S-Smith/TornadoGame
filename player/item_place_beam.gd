extends RayCast3D

@onready var inventory: Node = $"../../../Inventory"
@onready var item_place_beam: RayCast3D = $"."

var current_checker = null


var wind_probe_check = preload("res://gagets/windprobe/probe_check_placedown.tscn")

func _physics_process(delta: float) -> void:
	if item_place_beam.is_colliding():
		if inventory.current_item == inventory.Item.NULL_ITEM:
			delete_all_beam_children()
			return
		if inventory.current_item == inventory.Item.WIND_PROBE:
			if item_place_beam.get_child_count() == 0:
				spawn_checker(wind_probe_check)
			item_place_beam.get_child(0).global_position = item_place_beam.get_collision_point()
			item_place_beam.get_child(0).global_rotation = Vector3.ZERO
			if Input.is_action_just_pressed("interact") and item_place_beam.get_child(0).can_be_placed:
				item_place_beam.get_child(0).place()
				inventory.use_current_item()
	else:
		delete_all_beam_children()


func delete_all_beam_children() -> void:
	if item_place_beam.get_child_count() != 0:
		for child in item_place_beam.get_children():
			child.queue_free()

func spawn_checker(path) -> void:
	var dummy = path.instantiate()
	item_place_beam.add_child(dummy)
