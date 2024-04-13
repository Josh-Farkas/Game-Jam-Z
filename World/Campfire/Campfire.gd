extends StaticBody2D



var max_fuel: float = 100.0
var fuel: float = 25.0
var fuel_loss_rate: int = .5 # per second

var hovered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fuel -= fuel_loss_rate * delta
	$PointLight2D.energy = fuel / 4


func add_fuel(amount):
	fuel = min(fuel + amount, max_fuel)

func _on_click_area_mouse_entered():
	hovered = true


func _on_click_area_mouse_exited():
	hovered = false
