extends Node

@onready var wind_probe_icon = preload("res://player/inventoryExtraStuff/wind_probe_icon.tscn")
@onready var flashlight_icon = preload("res://player/inventoryExtraStuff/flashlight_icon.tscn")

enum Item {NULL_ITEM, WIND_PROBE, VORTEX_PROBE, FLASHLIGHT}

var item_names = ["NULL_ITEM", "Wind Probe", "Vortex Probe", "Flashlight"]

#var inventory = [Item.FLASHLIGHT, Item.WIND_PROBE, Item.WIND_PROBE, Item.WIND_PROBE, Item.VORTEX_PROBE]
var inventory = [Item.WIND_PROBE, Item.WIND_PROBE, Item.WIND_PROBE]
var hover_index = 0

var current_item : Item

@onready var inventory_row: HBoxContainer = $"../Ui/InventoryRow"


var initial_inventory = [Item.FLASHLIGHT, Item.WIND_PROBE, Item.WIND_PROBE, Item.WIND_PROBE]

func _ready() -> void:
	
	if Global.save_player_inventory == null:
		Global.save_player_inventory = initial_inventory
	
	load_inventory_from_global()
	if len(inventory) > 0:
		current_item = inventory[0]
	for item in inventory:
		match item:
			Item.WIND_PROBE:
				add_item_icon_to_inventory(wind_probe_icon)
			Item.FLASHLIGHT:
				add_item_icon_to_inventory(flashlight_icon)
	change_current_item()

func _physics_process(delta: float) -> void:
	if len(inventory) >= 1 : change_current_item() #hack fix, make better if this project goes somewhere
	if Input.is_action_just_pressed("scroll_up"):
		valid_scroll_sound()
		if hover_index < len(inventory) - 1:
			hover_index += 1
		else:
			hover_index = 0
		change_current_item()
	if Input.is_action_just_pressed("scroll_down"):
		valid_scroll_sound()
		if hover_index > 0:
			hover_index -= 1
		else:
			hover_index = len(inventory) - 1
		change_current_item()

func change_current_item():
	$"../Cam/ItemHold/DummyProbe".visible = false
	$"../Cam/ItemHold/Flashlight".visible = false
	for i in inventory_row.get_children():
		i.bar.visible = false
	current_item = inventory[hover_index] if len(inventory) >= 1 else Item.NULL_ITEM
	if inventory_row.get_child_count() > hover_index:
		inventory_row.get_child(hover_index).bar.visible = true
	if current_item == Item.WIND_PROBE:
		$"../Cam/ItemHold/DummyProbe".visible = true
	if current_item == Item.FLASHLIGHT:
		$"../Cam/ItemHold/Flashlight".visible = true
		

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
	#save_inventory_to_global()

func get_current_item_name() -> String:
	return item_names[current_item]

func save_inventory_to_global() -> void:
	Global.save_player_inventory = inventory

func load_inventory_from_global() -> void:
	inventory = Global.save_player_inventory

func valid_scroll_sound() -> void:
	if len(inventory) > 1:
		$Scroll.play()
