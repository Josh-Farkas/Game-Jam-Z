extends StaticBody2D

@onready
var tree_scn: PackedScene = preload("res://World/Tree/Tree.tscn")

@onready
var world: Node2D = get_tree().get_first_node_in_group("World")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_tree(pos: Vector2):
	var tree: StaticBody2D = tree_scn.instantiate()
	tree.global_position = pos
	

func generate_trees(size: Vector2, density: int):
	for i in range(size.x * size.y * density / 10000):
		spawn_tree(Vector2(randi_range(0, size.x), randi_range(0, size.y))
