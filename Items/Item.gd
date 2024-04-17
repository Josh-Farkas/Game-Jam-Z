extends StaticBody2D
class_name Item

@onready
var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

@onready var stack_label: Label = $StackLabel

@export_category("Item Info")
@export var type = "Axe"
@export var amount = 1
var action: String = ""
var max_stack: int = 0
var tooltype: String = ""
var tile_pos: Vector2i = Vector2i(-1, -1)
var fuel_amount: int = 0
var placeable_on_water: bool = false

var player_in_range: bool = false
var speed = 80


# Called when the node enters the scene tree for the first time.
func _ready():
	set_type(type)
	set_amount(amount)

func set_type(name: String) -> void:
	var type: Dictionary = Main.item_types[name]
	$Sprite2D.texture = type.Sprite
	max_stack = type.MaxStack
	action = type.Action
	if type.get("TilePos") != null:
		tile_pos = type.TilePos
	if type.get("ToolType") != null:
		tooltype = type.ToolType
	if type.get("Fuel") != null:
		fuel_amount = type.Fuel
	if type.get("PlaceableOnWater") != null:
		placeable_on_water = type.PlaceableOnWater
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_range and (player.inventory.map(func(x: Item): return x.type if x != null and x.amount != x.max_stack else null).find(type) != -1 or player.inventory.find(null) != -1):
		position += global_position.direction_to(player.global_position) * speed * delta


func _on_pickup_area_body_entered(body):
	if body == player:
		player_in_range = true


func _on_pickup_area_body_exited(body):
	if body == player:
		player_in_range = false

func set_amount(new_amount):
	amount = new_amount
	stack_label.text = str(amount) if amount > 1 else ""

func change_amount(delta: int):
	set_amount(amount + delta)
