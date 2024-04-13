extends Node2D

const MAP_SIZE = Vector2(1000, 1000)

@onready
var objects: Node2D = get_node("Objects")

@onready
var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	objects.generate_objects(MAP_SIZE)
	player.position = MAP_SIZE / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
