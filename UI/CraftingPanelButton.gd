extends Button

@export var type = ""
var item_scn = load("res://Items/Item.tscn")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

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


func _on_pressed():
	for ingredient in Main.item_recipes[type].Ingredients:
		for item in player.inventory:
			if item == null or item.type != ingredient:
				continue
			
			player.remove_item_from_inv(player.inventory.find(item),Main.item_recipes[type].Ingredients[ingredient])
	
	get_parent().get_parent().get_parent().get_parent().populate_grid(true)
	
	var item: Item = item_scn.instantiate()
	var free_slot = player.inventory.find(null)
	item.type = type
	player.inventory[free_slot] = item
	player.inventory_gui.get_child(free_slot).icon = Main.item_types[item.type]["Sprite"]
	player.set_stack_label(free_slot)
