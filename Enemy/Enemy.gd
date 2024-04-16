extends CharacterBody2D

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var player: Player = get_tree().get_first_node_in_group("Player")

enum MODE {
	ROAM,
	CHASE,
}
var mode: MODE = MODE.CHASE
@export var speed = 60


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	
	move_and_slide()
			
