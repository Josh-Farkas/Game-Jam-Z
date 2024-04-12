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
	

func generate_trees(size: Vector2, density: float = .25, min_distance: int = 20, forest_scale: float = 3):
	#for i in range(size.x * size.y * density / 10000):
		#spawn_tree(Vector2(randi_range(0, size.x / min_distance) * min_distance, randi_range(0, size.y / min_distance) * min_distance))
	
	var noise := FastNoiseLite.new()
	noise.seed = randi_range(0, 1000)
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_gain = 0
	
	for x in range(0, size.x, min_distance):
		for y in range(0, size.y, min_distance):
			var odds := noise.get_noise_2d(x / forest_scale, y / forest_scale)
			if odds * density >= randf():
				spawn_tree(Vector2(x + randi_range(-min_distance/4, min_distance/4), y + randi_range(-min_distance/4, min_distance/4)))
			
	
