extends Node2D

const CHUNK_SIZE = Vector2(32*16, 20*16)

const TILEMAP_COORDS := {
	"Snow": Vector2i.ZERO,
	"Tree": Vector2i(1,0),
	"DeadTree": Vector2i(2,0),
	"Stone": Vector2i(0,1),
	"Campfire": Vector2i(0,4),
	"Anvil": Vector2i(3, 1),
	"Select": Vector2i(0, 3),
	"Grass": Vector2i(2, 2),
	"Coal": Vector2i(1,3),
	"Water": Vector2i(3,0),
	"Iron": Vector2i(2,3),
	"Uranium": Vector2i(3,3),
}

const DENSITIES: Dictionary = {
	"Tree": 0.2, "Rock": .075, "Coal":.015, "Grass": 0.3, "Iron":0.02, "Uranium":0.01,
}

var item_scn = preload("res://Items/Item.tscn")

@onready var tilemap: TileMap = $TileMap
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
var player_chunk: Vector2i = Vector2i.ZERO

var selection_coords = Vector2i.ZERO

var generated_chunks: Dictionary = {}

var seed: int = 1
var forest_noise := FastNoiseLite.new()
var river_noise := FastNoiseLite.new()
var ore_noise := FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if seed == 0: seed = randi_range(1,1000)
	forest_noise.seed = seed
	forest_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	forest_noise.fractal_gain = 0
	
	river_noise.seed = forest_noise.seed + 1
	river_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	river_noise.fractal_gain = 0
	river_noise.fractal_octaves = 2
	
	ore_noise.seed = forest_noise.seed + 2
	ore_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	ore_noise.fractal_gain = 0
	ore_noise.fractal_octaves = 2
	
	forest_noise.get_seamless_image(1000, 1000).save_jpg("res://World/NoiseImages/Noise.jpg")
	river_noise.get_seamless_image(1000, 1000).save_jpg("res://World/NoiseImages/RiverNoise.jpg")
	ore_noise.get_seamless_image(1000, 1000).save_jpg("res://World/NoiseImages/OreNoise.jpg")
	
	
	generate_chunks(Vector2i.ZERO)
	for x in range(-8*16, 8*16, 16):
		for y in range(-2.4*16, 2.6*16, 16):
			spawn_obj(TILEMAP_COORDS.Snow, Vector2i(x, y), 0)
	
	spawn_obj(TILEMAP_COORDS.Campfire, Vector2i(-1,-1))
	$Campfire.position = Vector2i(-8, -8)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var coords = tilemap.local_to_map(get_local_mouse_position())
	if coords != selection_coords:
		tilemap.erase_cell(2, selection_coords)
		tilemap.set_cell(2, coords, 0, TILEMAP_COORDS.Select)
		selection_coords = coords
	
	var new_chunk: Vector2i = floor(player.global_position / CHUNK_SIZE)
	if new_chunk != player_chunk:
		generate_chunks(new_chunk)
		player_chunk = new_chunk


func destroy(tile_pos: Vector2i):
	var data := tilemap.get_cell_tile_data(1, tile_pos)
	tilemap.erase_cell(1, tile_pos)
	if tilemap.get_cell_tile_data(0, tile_pos).get_custom_data("IsWater"):
		tilemap.set_cell(0, tile_pos, 0, Vector2i(3, 0), 0)
	else:
		tilemap.set_cell(0, tile_pos, 0, Vector2.ZERO, 1)
	var item: Item = item_scn.instantiate()
	item.type = data.get_custom_data("Drops")
	item.set_amount(randi_range(data.get_custom_data("DropAmount")[0], data.get_custom_data("DropAmount")[1]))
	if item.amount == 0: return
	drop_item(item, tilemap.map_to_local(tile_pos))


func drop_item(item: Item, pos: Vector2):
	item.position = pos
	add_child(item)


func generate_chunks(center_pos: Vector2i):
	for x in range(-1, 2):
		for y in range(-1, 2):
			var chunk_pos := center_pos + Vector2i(x, y)
			if not generated_chunks.get(chunk_pos, false):
				generate_objects(CHUNK_SIZE, chunk_pos, DENSITIES, 16, 5, 20, 20)
				generated_chunks[chunk_pos] = true
				

func spawn_obj(tile_coords: Vector2i, pos: Vector2, layer:int = 1, alt: int = 0):
	tilemap.set_cell(layer, tilemap.local_to_map(pos), 0, tile_coords, alt)


func generate_objects(size: Vector2, offset: Vector2i, densities: Dictionary, tile_size: int = 16, forest_scale: float = 3, river_scale: float = 20, ore_scale: float = 5):
	for x in range(offset.x * size.x, size.x + offset.x * size.x, tile_size):
		for y in range(offset.y * size.y, size.y + offset.y * size.y, tile_size):
			var pos = Vector2i(x, y)
			# value of the perlin noise scaled by forest_scale
			var forest_odds := clampf(forest_noise.get_noise_2d(x / forest_scale, y / forest_scale) + 0.5, 0, 1)
			var river_odds: float = river_noise.get_noise_2d((x + 20*16) / river_scale, (y+20*16) / river_scale)
			var ore_odds: float = -ore_noise.get_noise_2d(x / ore_scale, y / ore_scale)
			
			if abs(river_odds) < .1: # River thickness
				spawn_obj(TILEMAP_COORDS.Water, pos, 0)
				
			else: # not a water tile
				spawn_obj(TILEMAP_COORDS.Snow, pos, 0)

				if forest_odds * densities.Tree >= randf():
					if randf() < .95: spawn_obj(TILEMAP_COORDS.Tree, pos)
					else: spawn_obj(TILEMAP_COORDS.DeadTree, pos)
				elif forest_odds * densities.Rock >= randf():
					spawn_obj(TILEMAP_COORDS.Stone, pos)
				elif forest_odds * densities.Coal >= randf():
					spawn_obj(TILEMAP_COORDS.Coal, pos)
				elif (1 - forest_odds) * densities.Grass >= randf():
					spawn_obj(TILEMAP_COORDS.Grass, pos, 1, randi_range(0, 1))
					# generate ore, go rarest -> least rare
				elif ore_odds >= 1 - densities.Uranium and randf() > .5:
					spawn_obj(TILEMAP_COORDS.Uranium, pos)
				elif ore_odds >= 1 - densities.Iron and randf() > .5:
					spawn_obj(TILEMAP_COORDS.Iron, pos)
					print("Iron Spawned At ", pos)
					print("Player Pos, ", player.position)
