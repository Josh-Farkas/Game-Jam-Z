extends Node2D

const MAP_SIZE = Vector2(10000, 10000)

@onready
var trees: Node2D = get_node("Trees")

# Called when the node enters the scene tree for the first time.
func _ready():
	trees.generate_trees(MAP_SIZE, .5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
