extends CharacterBody2D

const INV_SIZE = 10

@export var speed = 100
var speed_modifier = 1
var inventory = [].resize(INV_SIZE)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * speed * speed_modifier
	
	move_and_slide()


func _input(event):
	pass
