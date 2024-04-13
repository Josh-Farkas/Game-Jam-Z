extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var inventory_gui: HBoxContainer = $Control/MarginContainer/Inventory

const INV_SIZE = 4

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

func update_animation():
	if (direction != Vector2.ZERO):
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction
	
	if (velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/walk"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/walk"] = true


func _on_pickup_range_body_entered(body):
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

func set_current_slot(slot):
	current_slot = slot
	inventory_gui.get_child(0).button_pressed = true
