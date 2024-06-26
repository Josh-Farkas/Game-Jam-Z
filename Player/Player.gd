extends CharacterBody2D
class_name Player

@onready var world: Node2D = get_tree().get_first_node_in_group("World")
@onready var tilemap: TileMap = world.get_node("TileMap")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var inventory_gui: HBoxContainer = $Control/MarginContainer/Inventory
@onready var healthbar: TextureProgressBar = $Control/MarginContainer2/HealthBar
@onready var crafting_panel: PanelContainer = $Control/HBoxContainer/CraftingPanel
@onready var destroy_timer: Timer = $DestroyTimer
@onready var scroll_timer: Timer = $ScrollTimer

const INV_SIZE: int = 10
const PLACE_RANGE: int = 100
const TOOL_USE_RANGE: int = 50
const HEAT_LOSS_RATE: float = 2 # per second
const HEAT_GAIN_RATE: float = .03
const MAX_HEAT_GAIN: float = 5.0 # per second
const HEAT_TICK_RATE: int = 5 # num frames per tick

@export var speed = 100
var speed_modifier: int = 1
var direction: Vector2 = Vector2.ZERO

var inventory: Array = []
var current_slot: int
var health: int = 100
var heat: float = 100
var heat_loss_modifier: float = 1.0

var destroying_tile_pos: Vector2i = Vector2i.ZERO
var frame: int = 0

func _ready():
	animation_tree.active = true
	inventory.resize(INV_SIZE)
	healthbar.value = health
	
	for i in INV_SIZE:
		var slot = preload("res://UI/ItemSlot.tscn").instantiate()
		slot.button_group = preload("res://UI/InventorySlotButtonGroup.tres")
		inventory_gui.add_child(slot)
	
	set_current_slot(0)


func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * speed * speed_modifier
	
	if frame % HEAT_TICK_RATE == 0:
		heat -= HEAT_LOSS_RATE * heat_loss_modifier * world.time * HEAT_TICK_RATE * delta
		# Heat calculations, sums fuel-squared distance to all campfires and does some other math to make it balanced
		heat += clamp(HEAT_GAIN_RATE * get_tree().get_nodes_in_group("Campfire").map(func(c): return max(0, 100 * c.fuel - global_position.distance_squared_to(c.global_position)) / 10).reduce(func(d, c): return c + d) * HEAT_TICK_RATE  * delta, 0, MAX_HEAT_GAIN)
		heat = clamp(heat, 0, 100)
	
	if not destroy_timer.is_stopped() and get_tilemap_mouse_position() != destroying_tile_pos and Input.is_action_pressed("left_click"):
		destroy_timer.stop()

	move_and_slide()
	update_animation()
	frame += 1
	frame %= HEAT_TICK_RATE
	

func _input(event):
	if not crafting_panel.visible:
		if Input.is_action_just_pressed("dev_mode"):
			$CollisionShape2D.disabled = true
			speed = 500
		if Input.is_action_just_pressed("left_click"):
			use_item(inventory[current_slot])
			
		if Input.is_action_just_pressed("right_click"):
			match get_hovered_cell_data("ClickAction"):
				"Fuel": fuel()
				"Craft": pass
				"Break": pass

		if Input.is_action_just_released("scroll_up") and scroll_timer.is_stopped():
			set_current_slot(current_slot - 1 if current_slot > 0 else INV_SIZE - 1)
			scroll_timer.start()
		if Input.is_action_just_released("scroll_down") and scroll_timer.is_stopped():
			set_current_slot(current_slot + 1 if current_slot < INV_SIZE - 1 else 0)
			scroll_timer.start()
	
	if Input.is_action_just_pressed("toggle_menu"):
		crafting_panel.visible = not crafting_panel.visible
		
		for i in inventory_gui.get_children():
			i.mouse_filter = Control.MOUSE_FILTER_IGNORE if crafting_panel.visible else Control.MOUSE_FILTER_STOP

func use_item(item: Item) -> void:
	print("Using: ", item)
	if inventory[current_slot] == null:
		destroy(null)
	else:
		match item.action:
			"Attack": attack(item)
			"Destroy": destroy(item)
			"Place": if not place(item): destroy(item)
			"None": pass

func destroy(item: Item):
	if global_position.distance_to(get_global_mouse_position()) > TOOL_USE_RANGE or get_hovered_cell_data("ToolType") == null: return
	if get_hovered_cell_data("ToolType") == "Any" or (item and item.tooltype == get_hovered_cell_data("ToolType")):
		destroy_timer.start(get_hovered_cell_data("DestroyTime"))
		destroying_tile_pos = get_tilemap_mouse_position()

func attack(item: Item) -> void:
	pass
	
func place(item: Item) -> bool:
	if global_position.distance_to(get_global_mouse_position()) > PLACE_RANGE \
	or tilemap.get_cell_tile_data(1, get_tilemap_mouse_position()) != null: return false
	
	if item.placeable_on_water:
		if tilemap.get_cell_tile_data(0, get_tilemap_mouse_position()).get_custom_data("IsWater"):
			tilemap.set_cell(1, get_tilemap_mouse_position(), 0, item.tile_pos)
			tilemap.set_cell(0, get_tilemap_mouse_position(), 0, Vector2i(3, 0), 1)
		else: return false
	
	else:
		if not tilemap.get_cell_tile_data(0, get_tilemap_mouse_position()).get_custom_data("IsWater"):
			tilemap.set_cell(1, get_tilemap_mouse_position(), 0, item.tile_pos)
			tilemap.set_cell(0, get_tilemap_mouse_position(), 0, Vector2.ZERO, 1)
		else: return false
	
	if item.type == "Campfire":
		var campfire: Campfire = load("res://World/Campfire/Campfire.tscn").instantiate()
		campfire.global_position = tilemap.map_to_local(get_tilemap_mouse_position())
		world.add_child(campfire)
	
	remove_item_from_inv(current_slot, 1)
	return true


func fuel():
	if inventory[current_slot] == null or inventory[current_slot].fuel_amount == 0: return
	print('a')
	var campfire: Campfire = get_tree().get_nodes_in_group("Campfire").reduce(
		func(x: Campfire, val: Campfire): return x if global_position.distance_squared_to(x.global_position) < global_position.distance_squared_to(val.global_position) else val)
	campfire.add_fuel(inventory[current_slot].fuel_amount)
	remove_item_from_inv(current_slot, 1)
	#get_tilemap_mouse_position()


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
				inventory_gui.get_child(slot).icon = Main.item_types[body.type]["Sprite"]
				body.get_parent().remove_child(body)
				set_stack_label(slot)
				return
			else:
				var amount_to_fill = inventory[slot].max_stack - inventory[slot].amount
				inventory[slot].change_amount(min(body.amount, amount_to_fill))
				body.change_amount(-amount_to_fill)
				set_stack_label(slot)
	
	body.get_parent().remove_child(body)

func set_current_slot(slot) -> void:
	current_slot = slot
	inventory_gui.get_child(slot).button_pressed = true

func remove_item_from_inv(slot, amount) -> void:
	inventory[slot].change_amount(-amount)
	set_stack_label(slot)
	if inventory[slot].amount <= 0:
		inventory[slot].queue_free()
		inventory_gui.get_child(slot).icon = null
		inventory[slot] = null

func set_stack_label(slot):
	inventory_gui.get_child(slot).get_child(0).text = str(inventory[slot].amount) if inventory[slot].amount > 1 else ""

func _on_destroy_timer_timeout():
	world.destroy(get_tilemap_mouse_position())
