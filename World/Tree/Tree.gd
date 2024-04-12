extends StaticBody2D

const HIT_DISTANCE := 16

@onready
var item_scn := preload("res://Items/Item.tscn")

@onready
var world := get_tree().get_first_node_in_group("World")

var hovered: bool = false
var health: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_hit() -> bool:
	if !hovered: return false
	health -= 1
	print(health)
	if health == 0:
		fall()
	return true

func shake():
	pass

func fall():
	for n in range(randi_range(2,4)):
		var wood := item_scn.instantiate()
		wood.global_position = global_position + Vector2(randi_range(-2, 2), randi_range(-2, 2))
		world.add_child(wood)
	
	queue_free()

func _on_click_area_mouse_shape_entered(shape_idx):
	hovered = true
	
	
func _on_click_area_mouse_shape_exited(shape_idx):
	hovered = false
	
