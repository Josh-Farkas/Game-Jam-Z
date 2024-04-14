extends Button

@export var type = ""

func _ready():
	icon = Main.item_types[type].Sprite

func _on_mouse_entered():
	if mouse_filter == MOUSE_FILTER_IGNORE:
		return
	
	var ingredients_panel = preload("res://UI/CraftingIngredientsPanel.tscn").instantiate()
	ingredients_panel.result = type
	add_child(ingredients_panel)


func _on_mouse_exited():
	if mouse_filter == MOUSE_FILTER_IGNORE:
		return
	
	for i in get_children():
		i.queue_free()
