extends StaticBody2D
class_name Item

static var item_types: Dictionary = {
	"Wood": {
		"Sprite": preload("res://Items/Wood.png"),
		"MaxStack": 20,
		"Action": "None",
		"Fuel": 10,
	},
	"Stone": {
		"Sprite": preload("res://Items/Stone.png"),
		"MaxStack": 20,
		"Action": "None",
	},
	"Coal": {
		"Sprite": preload("res://Items/Coal.png"),
		"MaxStack": 20,
		"Action": "None",
		"Fuel": 25,
	},
	"Iron": {
		"Sprite": preload("res://Items/Coal.png"),
		"MaxStack": 20,
		"Action": "None",
	},
	"Uranium": {
		"Sprite": preload("res://Items/Coal.png"),
		"MaxStack": 20,
		"Action": "None",
	},
	"Fiber": {
		"Sprite": preload("res://Items/Fiber.png"),
		"MaxStack": 20,
		"Action": "None",
		"Fuel": 2,
	},
	"Anvil": {
		"Sprite": preload("res://Items/Anvil.png"),
		"MaxStack": 1,
		"Action": "Place",
		"TilePos": Vector2i(3, 1)
	},
	"Furnace": {
		"Sprite": preload("res://Items/Anvil.png"),
		"MaxStack": 1,
		"Action": "Place",
		"TilePos": Vector2i(6, 0)
	},
	"Campfire": {
		"Sprite": preload("res://Items/Campfire.png"),
		"MaxStack": 1,
		"Action": "Place",
		"TilePos": Vector2i(0, 4)
	},
	"Spike": {
		"Sprite": preload("res://Items/Spike.png"),
		"MaxStack": 1,
		"Action": "Place",
		"TilePos": Vector2i(5, 1)
	},
	"Bridge": {
		"Sprite": preload("res://Items/Bridge.png"),
		"MaxStack": 10,
		"Action": "Place",
		"TilePos": Vector2i(3, 2),
		"PlaceableOnWater": true,
	},
	"Axe": {
		"Sprite": preload("res://Items/Axe.png"),
		"MaxStack": 1,
		"Action": "Destroy",
		"ToolType": "Axe",
	},
	"Pickaxe": {
		"Sprite": preload("res://Items/Axe.png"),
		"MaxStack": 1,
		"Action": "Destroy",
		"ToolType": "Pickaxe",
	},
	"BattleAxe": {
		"Sprite": preload("res://Items/BattleAxe.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
	"Broadsword": {
		"Sprite": preload("res://Items/Broadsword.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
	"Knife": {
		"Sprite": preload("res://Items/Knife.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
	"Mallet": {
		"Sprite": preload("res://Items/Mallet.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
	"Shiv": {
		"Sprite": preload("res://Items/Shiv.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
	"Sword": {
		"Sprite": preload("res://Items/Sword.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
}

@onready
var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

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
	var type: Dictionary = item_types[name]
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

func change_amount(delta: int):
	set_amount(amount + delta)
