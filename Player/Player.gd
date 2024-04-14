extends CharacterBody2D
class_name Player

@onready var world: Node2D = get_tree().get_first_node_in_group("World")
@onready var tilemap: TileMap = world.get_node("TileMap")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var inventory_gui: HBoxContainer = $Control/MarginContainer/Inventory
@onready var healthbar: TextureProgressBar = $Control/MarginContainer2/HealthBar
@onready var destroy_timer: Timer = $DestroyTimer

const INV_SIZE = 10
const PLACE_RANGE = 100
const TOOL_USE_RANGE = 50

@export var speed = 100
var speed_modifier: int = 1
var direction: Vector2 = Vector2.ZERO

var inventory: Array = []
var current_slot: int

var health: int = 100

var destroying_tile_pos: Vector2i = Vector2i.ZERO


func _ready():
	animation_tree.active = true
	inventory.resize(INV_SIZE)
	healthbar.value = health
	
	for i in INV_SIZE:
		var slot = preload("res://UI/inventory_slot.tscn").instantiate()
		slot.button_group = preload("res://UI/InventorySlotButtonGroup.tres")
		inventory_gui.add_child(slot)
	
	set_current_slot(0)


func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * speed * speed_modifier
	
	if not destroy_timer.is_stopped() and get_tilemap_mouse_position() != destroying_tile_pos and Input.is_action_pressed("left_click"):
		destroy_timer.stop()

	move_and_slide()
	update_animation()
	

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		if inventory[current_slot] != null:
			use_item(inventory[current_slot])
		else:
			match get_hovered_cell_data("ClickAction"):
				"Break": pass
	
	if Input.is_action_just_pressed("right_click"):
		match get_hovered_cell_data("ClickAction"):
			"Fuel": pass
			"Break": pass

	if Input.is_action_just_released("scroll_up"):
		set_current_slot(current_slot - 1 if current_slot > 0 else INV_SIZE - 1)
	if Input.is_action_just_released("scroll_down"):
		set_current_slot(current_slot + 1 if current_slot < INV_SIZE - 1 else 0)
	
				

func use_item(item: Item) -> void:
	print("Using: ", item)
	match item.action:
		"Attack": attack(item)
		"Destroy": destroy(item)
		"Place": place(item)
		"None": pass

func destroy(item: Item):
	if global_position.distance_to(get_global_mouse_position()) > TOOL_USE_RANGE or get_hovered_cell_data("ToolType") == null: return
	if item.tooltype == get_hovered_cell_data("ToolType") or get_hovered_cell_data("ToolType") == "Any":
		destroy_timer.start(get_hovered_cell_data("DestroyTime"))
		destroying_tile_pos = get_tilemap_mouse_position()

func attack(item: Item) -> void:
	pass
	
func place(item: Item) -> void:
	if global_position.distance_to(get_global_mouse_position()) > PLACE_RANGE: return
	#var cell_data := get_hovered_cell_data("placeable")
	#if not cell_data.get_custom_data("placeable"): return
	#
	#tilemap.set_cell(1, get_tilemap_mouse_position(), item.tileset_pos)
	#
	#inventory[current_slot].amount -= 1
	#if inventory[current_slot].amount <= 0:
		#inventory[current_slot].queue_free()
		#inventory_gui.get_child(current_slot).icon = null
		#inventory[current_slot] = null

func get_tilemap_mouse_position():
	return tilemap.local_to_map(tilemap.get_local_mouse_position())


func get_hovered_cell_data(layer_name) -> Variant:
	var tile := tilemap.get_cell_tile_data(1, get_tilemap_mouse_position())
	if tile != null:
		return tile.get_custom_data(layer_name)
	return null


func update_animation() -> void:
	if (direction != Vector2.ZERO):
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction
	
	if (velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/walk"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/walk"] = true


func _on_pickup_range_body_entered(body) -> void:
	if not body is Item: return
	
	while body.amount > 0:
		var slot: int = inventory.map(func(x: Item): return x.type if x != null and x.amount != x.max_stack else null).find(body.type)
		if slot == -1: slot = inventory.find(null)
		
		if (slot != -1):
			if inventory[slot] == null: 
				inventory[slot] = body
				inventory_gui.get_child(slot).icon = body.item_types[body.type]["Sprite"]
				inventory_gui.get_child(slot).get_child(0).text = str(body.amount) if body.amount > 1 else ""
				body.get_parent().remove_child(body)
				return
			else:
				var amount_to_fill = inventory[slot].max_stack - inventory[slot].amount
				inventory[slot].change_amount(min(body.amount, amount_to_fill))
				inventory_gui.get_child(slot).get_child(0).text = str(inventory[slot].amount) if inventory[slot].amount > 1 else ""
				body.change_amount(-amount_to_fill)
	
	body.get_parent().remove_child(body)

func set_current_slot(slot) -> void:
	current_slot = slot
	inventory_gui.get_child(slot).button_pressed = true


func _on_destroy_timer_timeout():
	world.destroy(get_tilemap_mouse_position())
