extends Node

@onready var wind_probe_icon = preload("res://player/inventoryExtraStuff/wind_probe_icon.tscn")

enum Item {NULL_ITEM, WIND_PROBE, VORTEX_PROBE, FLASHLIGHT}

var item_names = ["NULL_ITEM", "Wind Probe", "Vortex Probe", "Flashlight"]

#var inventory = [Item.FLASHLIGHT, Item.WIND_PROBE, Item.WIND_PROBE, Item.WIND_PROBE, Item.VORTEX_PROBE]
var inventory = [Item.WIND_PROBE, Item.WIND_PROBE, Item.WIND_PROBE]
var hover_index = 0

var current_item : Item

@onready var inventory_row: HBoxContainer = $"../Ui/InventoryRow"



func _ready() -> void:
	current_item = inventory[0]
	for item in inventory:
		match item:
			Item.WIND_PROBE:
				add_item_icon_to_inventory(wind_probe_icon)
	change_current_item()

func _physics_process(delta: float) -> void:
	if len(inventory) >= 1 : change_current_item() #hack fix, make better if this project goes somewhere
	if Input.is_action_just_pressed("scroll_up"):
		if hover_index < len(inventory) - 1:
			hover_index += 1
		else:
			hover_index = 0
		change_current_item()
	if Input.is_action_just_pressed("scroll_down"):
		if hover_index > 0:
			hover_index -= 1
		else:
			hover_index = len(inventory) - 1
		change_current_item()

func change_current_item():
	$"../Cam/ItemHold/DummyProbe".visible = false
	for i in inventory_row.get_children():
		i.bar.visible = false
	current_item = inventory[hover_index] if len(inventory) >= 1 else Item.NULL_ITEM
	inventory_row.get_child(hover_index).bar.visible = true
	if current_item == Item.WIND_PROBE:
		$"../Cam/ItemHold/DummyProbe".visible = true

func add_item_icon_to_inventory(item_ref) -> void:
	var item = item_ref.instantiate()
	$"../Ui/InventoryRow".add_child(item)

func remove_item_icon_from_inventory(item_id) -> void:
	inventory_row.get_child(item_id).queue_free()

func use_current_item() -> void:
	inventory.remove_at(hover_index)
	remove_item_icon_from_inventory(hover_index)
	if hover_index == len(inventory) and hover_index != 0:
		hover_index -= 1
	change_current_item()
