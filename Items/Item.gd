extends CollisionShape2D

@onready
var item_types: Dictionary = {
	"Wood": {
		"Sprite": preload("res://icon.svg")
	},
	
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_type(name: String) -> void:
	$Sprite2D.texture = item_types[name]["Sprite"]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_range:
		position += position.direction_to(player)
