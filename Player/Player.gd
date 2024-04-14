extends CharacterBody2D

@onready var world: Node2D = get_tree().get_first_node_in_group("World")
@onready var tilemap: TileMap = world.get_node("TileMap")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var inventory_gui: HBoxContainer = $Control/MarginContainer/Inventory

const INV_SIZE = 10
const PLACE_RANGE = 100

@export var speed = 100
var speed_modifier: int = 1
var inventory: Array = []

var direction: Vector2 = Vector2.ZERO

var current_slot: int

func _ready():
	animation_tree.active = true
	inventory.resize(INV_SIZE)
	
	for i in INV_SIZE:
		var slot = preload("res://UI/inventory_slot.tscn").instantiate()
		slot.button_group = preload("res://Player/InventorySlotButtonGroup.tres")
		inventory_gui.add_child(slot)
	
	set_current_slot(0)

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * speed * speed_modifier

	move_and_slide()
	update_animation()
		
		

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		if inventory[current_slot] != null and inventory[current_slot].action != "None":
			use_item(inventory[current_slot])
		else:
			match get_hovered_cell_data().get_custom_data("ClickAction"):
				"Break": pass
				

func use_item(item: Item) -> void:
	match item.action:
		"Attack": attack(item)
		"Place": place(item)
	

func attack(item: Item) -> void:
	pass
	
func place(item: Item) -> void:
	if global_position.distance_to(get_global_mouse_position()) > PLACE_RANGE: return
	var cell_data := get_hovered_cell_data()
	if not cell_data.get_custom_data("placeable"): return
	
	tilemap.set_cell(1, tilemap.local_to_map(tilemap.get_local_mouse_position()), item.tileset_id)
	
	inventory[current_slot].amount -= 1
	if inventory[current_slot].amount <= 0:
		inventory[current_slot].queue_free()
		inventory_gui.get_child(current_slot).icon = null
		inventory[current_slot] = null


func get_hovered_cell_data() -> TileData:
	var clicked_cell = tilemap.local_to_map(tilemap.get_local_mouse_position())
	var data: TileData = tilemap.get_cell_tile_data(0, clicked_cell)
	return data


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
				inventory_gui.get_child(slot).icon = body.item_types[body.type].Sprite
				body.get_parent().remove_child(body)
				return
			else:
				var amount_to_fill = inventory[slot].max_stack - inventory[slot].amount
				inventory[slot].change_amount(min(body.amount, amount_to_fill))
				body.change_amount(-amount_to_fill)
	
	body.get_parent().remove_child(body)

func set_current_slot(slot) -> void:
	current_slot = slot
	inventory_gui.get_child(0).button_pressed = true
