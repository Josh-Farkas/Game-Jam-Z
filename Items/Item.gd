extends StaticBody2D
class_name Item

@onready
var item_types: Dictionary = {
	"Wood": {
		"Sprite": preload("res://Items/Wood.png"),
		"MaxStack": 3
	},
	"Stone": {
		"Sprite": preload("res://Items/Stone.png"),
		"MaxStack": 3
	},
	"Axe": {
		"Sprite": preload("res://Items/Axe.png"),
		"MaxStack": 1
	},
	"BattleAxe": {
		"Sprite": preload("res://Items/BattleAxe.png"),
		"MaxStack": 1
	},
	"Broadsword": {
		"Sprite": preload("res://Items/Broadsword.png"),
		"MaxStack": 1
	},
	"Knife": {
		"Sprite": preload("res://Items/Knife.png"),
		"MaxStack": 1
	},
	"Mallet": {
		"Sprite": preload("res://Items/Mallet.png"),
		"MaxStack": 1
	},
	"Shiv": {
		"Sprite": preload("res://Items/Shiv.png"),
		"MaxStack": 1
	},
	"Sword": {
		"Sprite": preload("res://Items/Sword.png"),
		"MaxStack": 1
	},
}

var type = "Axe"

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
	$Sprite2D.texture = item_types[name]["Sprite"]
	max_stack = item_types[name]["MaxStack"]

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
