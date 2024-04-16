extends CharacterBody2D

const ENEMY_DATA := {
	"Cyclops": {
		"Health": 30,
		"Damage": 15,
		"Defense": 4,
		"Speed": 65,
		"Flying":false,
		"Drops": {
			"Club": .1,
			"Potion": {"Odds":.1, "Amount": [1,1]},
		}
	},
	"Bat": {
		"Health": 10,
		"Damage": 5,
		"Defense": 0,
		"Speed": 110,
		"Flying": true,
		"Drops": {
			
		}
	},
	
}

@onready var item_scn: PackedScene = preload("res://Items/Item.tscn")

@onready var world: World = get_tree().get_first_node_in_group("World")
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var player: Player = get_tree().get_first_node_in_group("Player")

enum MODE {
	ROAM,
	CHASE,
}
var mode: MODE = MODE.CHASE

var health: int = 1
var damage: int = 1
var defense: int = 0
var speed: int = 50
var flying := false
var drops := {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_type(type: String):
	var typedata: Dictionary = ENEMY_DATA[type]
	health = typedata.Health
	damage = typedata.Damage
	defense = typedata.Defense
	speed = typedata.Speed
	flying = typedata.Flying
	drops = typedata.Drops
	
	$Sprites.get_node(type).visible = true
	if flying:
		$CollisionShape2D.disabled = true
		nav.navigation_layers = 0b11
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	var direction = Vector2()
	match mode:
		MODE.CHASE:
			nav.target_position = player.global_position
			direction = (nav.get_next_path_position() - global_position).normalized()
			velocity = direction * speed
		
		MODE.ROAM:
			pass
			#nav.target_position = ve
	
	move_and_slide()


func die():
	drop_items()
	queue_free()

func drop_items():
	for item_name: String in drops:
		var amount = drops[item_name].Amount
		if amount != 0:
			var item: Item = item_scn.instantiate()
			item.set_type(item_name)
			item.amount = amount
			world.drop_item(item, global_position)
