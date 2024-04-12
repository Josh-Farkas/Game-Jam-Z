extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

const INV_SIZE = 10

@export var speed = 100
var speed_modifier: int = 1
var inventory: Array = []

var direction: Vector2 = Vector2.ZERO

func _ready():
	inventory.resize(INV_SIZE)
	#animation_tree.active = true

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * speed * speed_modifier

	move_and_slide()
	#update_animation()

func update_animation():
	if (direction != Vector2.ZERO):
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction
	
	if (velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/walk"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/walk"] = true
