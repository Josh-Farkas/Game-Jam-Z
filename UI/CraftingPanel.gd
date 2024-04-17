extends PanelContainer

@export var type = "Hand"

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var crafting_buttons_container: GridContainer = $MarginContainer/VBoxContainer/CraftingButtonsContainer

func get_all_items_in_inv():
	var result: Dictionary = {}
	
	for i in player.inventory:
		if i == null:
			continue
		if result.get(i.type) == null: result[i.type] = 0
		result[i.type] += i.amount
	
	return result

func get_all_craftable_items():
	var all_items: Dictionary = get_all_items_in_inv()
	var valid_items := []

	for item in Main.item_recipes:
		var ingredients = Main.item_recipes[item].Ingredients
		var can_make: bool = true
		for ingredient in ingredients:
			if not all_items.get(ingredient) or all_items[ingredient] < ingredients[ingredient]:
				can_make = false
				break
		if can_make:
			valid_items.append(item)
	
	return valid_items


func _on_visibility_changed():
	if not visible:
		for child in crafting_buttons_container.get_children():
			child.queue_free()
		return
	
	populate_grid(false)

func populate_grid(reset):
	if reset:
		for child in crafting_buttons_container.get_children():
			child.queue_free()
	
	for i in Main.item_recipes:
		var slot = preload("res://UI/CraftingPanelButton.tscn").instantiate()
		slot.type = i
		
		if not get_all_craftable_items().has(i):
			slot.disabled = true
		
		crafting_buttons_container.add_child(slot)
