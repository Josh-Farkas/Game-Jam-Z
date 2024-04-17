extends Node

static var item_types: Dictionary = {
	"Wood": {
		"Sprite": preload("res://Items/Wood.png"),
		"MaxStack": 20,
		"Action": "None",
		"Fuel": 10,
	},
	"Stone": {
		"Sprite": preload("res://Items/Stone.png"),
		"MaxStack": 20,
		"Action": "None",
	},
	"Coal": {
		"Sprite": preload("res://Items/Coal.png"),
		"MaxStack": 20,
		"Action": "None",
		"Fuel": 25,
	},
	"Iron": {
		"Sprite": preload("res://Items/Coal.png"),
		"MaxStack": 20,
		"Action": "None",
	},
	"Uranium": {
		"Sprite": preload("res://Items/Coal.png"),
		"MaxStack": 20,
		"Action": "None",
	},
	"Fiber": {
		"Sprite": preload("res://Items/Fiber.png"),
		"MaxStack": 20,
		"Action": "None",
		"Fuel": 2,
	},
	"Anvil": {
		"Sprite": preload("res://Items/Anvil.png"),
		"MaxStack": 1,
		"Action": "Place",
		"TilePos": Vector2i(3, 1)
	},
	"Furnace": {
		"Sprite": preload("res://Items/Anvil.png"),
		"MaxStack": 1,
		"Action": "Place",
		"TilePos": Vector2i(6, 0)
	},
	"Campfire": {
		"Sprite": preload("res://Items/Campfire.png"),
		"MaxStack": 1,
		"Action": "Place",
		"TilePos": Vector2i(0, 4)
	},
	"Spike": {
		"Sprite": preload("res://Items/Spike.png"),
		"MaxStack": 1,
		"Action": "Place",
		"TilePos": Vector2i(5, 1)
	},
	"Bridge": {
		"Sprite": preload("res://Items/Bridge.png"),
		"MaxStack": 10,
		"Action": "Place",
		"TilePos": Vector2i(3, 2),
		"PlaceableOnWater": true,
	},
	"Axe": {
		"Sprite": preload("res://Items/Axe.png"),
		"MaxStack": 1,
		"Action": "Destroy",
		"ToolType": "Axe",
	},
	"Pickaxe": {
		"Sprite": preload("res://Items/Pickaxe.png"),
		"MaxStack": 1,
		"Action": "Destroy",
		"ToolType": "Pickaxe",
	},
	"BattleAxe": {
		"Sprite": preload("res://Items/BattleAxe.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
	"Broadsword": {
		"Sprite": preload("res://Items/Broadsword.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
	"Knife": {
		"Sprite": preload("res://Items/Knife.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
	"Mallet": {
		"Sprite": preload("res://Items/Mallet.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
	"Shiv": {
		"Sprite": preload("res://Items/Shiv.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
	"Sword": {
		"Sprite": preload("res://Items/Sword.png"),
		"MaxStack": 1,
		"Action": "Attack",
	},
}

static var item_recipes: Dictionary = {
	"Axe": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 5}
	},
	"Pickaxe": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 5}
	},
	"BattleAxe": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 10}
	},
	"Broadsword": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 4}
	},
	"Knife": {
		"Amount": 1,
		"Ingredients": {"Wood": 3, "Stone": 2}
	},
	"Mallet": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 4}
	},
	"Shiv": {
		"Amount": 1,
		"Ingredients": {"Wood": 2, "Stone": 1}
	},
	"Sword": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 4}
	},
}
