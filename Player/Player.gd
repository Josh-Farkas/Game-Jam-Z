extends CharacterBody2D

const INV_SIZE = 10

@export var speed = 100
var speed_modifier: int = 1
var inventory: Array = []

func _ready():
	inventory.resize(INV_SIZE)
	

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * speed * speed_modifier

	move_and_slide()


func _input(event):
	pass
