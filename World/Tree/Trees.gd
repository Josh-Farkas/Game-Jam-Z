extends Node2D

@onready
var tree_scn: PackedScene = preload("res://World/Tree/Tree.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_tree(pos: Vector2):
	var tree: StaticBody2D = tree_scn.instantiate()
	tree.global_position = pos
	add_child(tree)
	

func generate_trees(size: Vector2, density: float, min_distance: int = 10):
	for i in range(size.x * size.y * density / 10000):
		spawn_tree(Vector2(randi_range(0, size.x / min_distance) * min_distance, randi_range(0, size.y / min_distance) * min_distance))
