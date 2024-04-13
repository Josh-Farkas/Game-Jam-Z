extends Node2D

@onready
var obj_scn: PackedScene = preload("res://World/Object/Object.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_obj(type: String, pos: Vector2):
	var obj: StaticBody2D = obj_scn.instantiate()
	obj.global_position = pos
	obj.type = type
	add_child(obj)


func generate_objects(size: Vector2, tree_density: float = .2, rock_density: float = 0.05, min_distance: int = 20, forest_scale: float = 3):
	#for i in range(size.x * size.y * density / 10000):
		#spawn_tree(Vector2(randi_range(0, size.x / min_distance) * min_distance, randi_range(0, size.y / min_distance) * min_distance))
	
	var noise := FastNoiseLite.new()
	noise.seed = randi_range(0, 1000)
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_gain = 0
	
	for x in range(0, size.x, min_distance):
		for y in range(0, size.y, min_distance):
			# prevent objects from spawning at 100x100 spawn area
			if x in range(size.x/2 - 50, size.x/2 + 50) and y in range(size.y/2 - 50, size.y/2 + 50): continue
			var odds := noise.get_noise_2d(x / forest_scale, y / forest_scale) ** 2
			if odds * tree_density >= randf():
				spawn_obj("Tree", Vector2(x + randi_range(-min_distance/3, min_distance/3), y + randi_range(-min_distance/3, min_distance/3)))
			elif odds * rock_density >= randf():
				spawn_obj("Rock", Vector2(x + randi_range(-min_distance/3, min_distance/3), y + randi_range(-min_distance/3, min_distance/3)))
