extends Node2D

const MAP_SIZE = Vector2(100*16, 100*16)

const TILEMAP_COORDS := {
	"Snow": Vector2.ZERO,
	"Tree": Vector2(1,0),
	"Rock": Vector2(0,1),
	"Campfire": Vector2(3,2),
	"Anvil": Vector2(3, 1),
	"Select": Vector2(0, 3),
}

@onready var tilemap: TileMap = $TileMap

@onready var player: CharacterBody2D = $Player

var selection_coords = Vector2i.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_objects(MAP_SIZE)
	player.position = MAP_SIZE / 2
	
	spawn_obj(TILEMAP_COORDS.Campfire, MAP_SIZE/2)
	$Campfire.position = MAP_SIZE/2
	

func _input(event):
	if event is InputEventMouseMotion:
		var coords = tilemap.local_to_map(get_local_mouse_position())
		if coords != selection_coords:
			tilemap.erase_cell(2, selection_coords)
			tilemap.set_cell(2, coords, 0, TILEMAP_COORDS.Select)
			selection_coords = coords

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_obj(tile_coords: Vector2, pos: Vector2):
	print('obj spawned')
	tilemap.set_cell(1, tilemap.local_to_map(pos), 0, tile_coords)


func generate_objects(size: Vector2, tree_density: float = .2, rock_density: float = 0.05, tile_size: int = 16, forest_scale: float = 3):
	var noise := FastNoiseLite.new()
	noise.seed = randi_range(0, 1000)
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_gain = 0
	
	for x in range(0, size.x, tile_size):
		for y in range(0, size.y, tile_size):
			# prevent objects from spawning at 100x100 spawn area
			if x in range(size.x/2 - 50, size.x/2 + 50) and y in range(size.y/2 - 50, size.y/2 + 50): continue
			var odds := noise.get_noise_2d(x / forest_scale, y / forest_scale) ** 2
			if odds * tree_density >= randf():
				spawn_obj(TILEMAP_COORDS.Tree, Vector2(x, y))
			elif odds * rock_density >= randf():
				spawn_obj(TILEMAP_COORDS.Rock, Vector2(x, y))
