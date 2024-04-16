extends Node2D
class_name Campfire

@onready var world: World = get_tree().get_first_node_in_group("World")

var colliding: bool = false

var max_fuel: float = 100.0
var fuel: float = 100
var fuel_loss_rate: float = .5 # per second

var hovered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fuel > 0:
		fuel -= fuel_loss_rate * delta
		fuel = max(0, fuel)
		#print(fuel)
		# make light dim during the day and bright during night
		$PointLight2D.energy = world.get_scaled_time(PI) * fuel / 100

func add_fuel(amount):
	fuel = min(fuel + amount, max_fuel)
