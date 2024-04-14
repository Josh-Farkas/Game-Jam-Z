extends StaticBody2D
class_name Item

@onready
var item_types: Dictionary = {
	"Wood": {
		"Sprite": preload("res://Items/Wood.png"),
		"MaxStack": 99,
		"Action": "Place",
		"PlaceableObject": preload("res://World/Campfire/Campfire.tscn"),
		"TileSetID": 0,
	},
	"Stone": {
		"Sprite": preload("res://Items/Stone.png"),
		"MaxStack": 99,
		"Action": "None",
	},
	"Axe": {
		"Sprite": preload("res://Items/Axe.png"),
		"MaxStack": 3,
		"Action": "Attack",
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

var type = "Axe"
var placeable_obj: PackedScene = null
var action: String = ""
var tileset_id = -1

@onready
var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

var player_in_range: bool = false
var speed = 100

var max_stack = 0
var amount = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_type(type)

func set_type(name: String) -> void:
	var type: Dictionary = item_types[name]
	$Sprite2D.texture = type.Sprite
	max_stack = type.MaxStack
	action = type.Action
	if type.get("PlaceableObject") != null:
		placeable_obj = type.PlaceableObject
		tileset_id = type.TileSetID
		

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
