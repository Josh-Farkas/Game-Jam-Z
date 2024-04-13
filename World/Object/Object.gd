extends StaticBody2D

const HIT_DISTANCE := 16

@onready
var item_scn := preload("res://Items/Item.tscn")

@onready
var world := get_tree().get_first_node_in_group("World")


@onready
var object_types = {
	"Tree": {
		"Health": 5,
		"Drops": "Wood",
		"DropAmount": [1, 4],
	},
	"Rock": {
		"Health": 6,
		"Drops": "Stone",
		"DropAmount": [2, 3],
	}
}

var type := "Tree"
var data: Dictionary = {}

var hovered: bool = false
var health: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	set_type(type)

func set_type(type: String) -> void:
	self.type = type
	data = object_types[type]
	health = data["Health"]
	$Sprites.get_node(type).visible = true
	
	# move collision shape to be a child
	var col: CollisionShape2D = $CollisionShapes.get_node(type)
	$CollisionShapes.remove_child(col)
	add_child(col)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if Input.is_action_just_pressed("left_click"):
		get_hit()

func get_hit() -> bool:
	if !hovered: return false
	health -= 1
	print(health)
	if health == 0:
		die()
	return true


func die():
	var item := item_scn.instantiate()
	item.type = data["Drops"]
	item.global_position = global_position + Vector2(randi_range(-2, 2), randi_range(-2, 2))
	item.set_amount(randi_range(data["DropAmount"][0], data["DropAmount"][1]))
	world.add_child(item)
	
	queue_free()

func _on_click_area_mouse_shape_entered(shape_idx):
	hovered = true


func _on_click_area_mouse_shape_exited(shape_idx):
	hovered = false
	
