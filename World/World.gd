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

var item_scn = preload("res://Items/Item.tscn")

@onready var tilemap: TileMap = $TileMap
@onready var player: CharacterBody2D = $Player

var selection_coords = Vector2i.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_objects(MAP_SIZE)
	player.position = MAP_SIZE / 2
	
	spawn_obj(TILEMAP_COORDS.Campfire, MAP_SIZE/2)
	$Campfire.position = MAP_SIZE/2
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var coords = tilemap.local_to_map(get_local_mouse_position())
	if coords != selection_coords:
		tilemap.erase_cell(2, selection_coords)
		tilemap.set_cell(2, coords, 0, TILEMAP_COORDS.Select)
		selection_coords = coords


func destroy(tile_pos: Vector2i):
	var data := tilemap.get_cell_tile_data(1, tile_pos)
	tilemap.erase_cell(1, tile_pos)
	var item: Item = item_scn.instantiate()
	item.type = data.get_custom_data("Drops")
	item.set_amount(randi_range(data.get_custom_data("DropAmount")[0], data.get_custom_data("DropAmount")[1]))
	drop_item(item, tilemap.map_to_local(tile_pos))


func drop_item(item: Item, pos: Vector2):
	item.position = pos
	add_child(item)

func spawn_obj(tile_coords: Vector2, pos: Vector2):
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
