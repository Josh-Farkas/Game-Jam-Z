extends Node2D
class_name Campfire

var colliding: bool = false

var max_fuel: float = 100.0
var fuel: float = 50
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
		$PointLight2D.energy = fuel / 200

func add_fuel(amount):
	fuel = min(fuel + amount, max_fuel)
