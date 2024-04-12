extends Node2D
class_name Item

@onready
var item_types: Dictionary = {
	"Wood": {
		"Sprite": preload("res://icon.svg")
	},
	"Stone": {
		"Sprite": preload("res://icon.svg")
	},
}
var type = "Wood"

@onready
var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

var player_in_range: bool = false
var speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	set_type(type)

func set_type(name: String) -> void:
	$Sprite2D.texture = item_types[name]["Sprite"]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_range:
		print("in range")
		position += global_position.direction_to(player.global_position) * speed * delta


func _on_pickup_area_body_entered(body):
	if body == player:
		player_in_range = true


func _on_pickup_area_body_exited(body):
	if body == player:
		player_in_range = false
