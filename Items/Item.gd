extends CollisionShape2D

@onready
var item_types: Dictionary = {
	"Wood": {
		"Sprite": preload("res://icon.svg")
	},
	
}

@onready
var player = get_tree().get_first_node_in_group("Player")

var player_in_range: bool = false
var speed = 15


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_type(name: String) -> void:
	$Sprite2D.texture = item_types[name]["Sprite"]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_range:
		position += position.direction_to(player) * speed * delta


func _on_pickup_area_body_entered(body):
	if body == player:
		player_in_range = true


func _on_pickup_area_body_exited(body):
	if body == player:
		player_in_range = false
