extends Panel

<<<<<<< Updated upstream
static var item_recipes: Dictionary = {
	"Axe": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 5}
	},
	"Pickaxe": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 5}
	},
	"BattleAxe": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 10}
	},
	"Broadsword": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 4}
	},
	"Knife": {
		"Amount": 1,
		"Ingredients": {"Wood": 3, "Stone": 2}
	},
	"Mallet": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 4}
	},
	"Shiv": {
		"Amount": 1,
		"Ingredients": {"Wood": 2, "Stone": 1}
	},
	"Sword": {
		"Amount": 1,
		"Ingredients": {"Wood": 5, "Stone": 4}
	},
}

@export var menu_type = "Hand"

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var craftable_items_container: GridContainer = $MarginContainer/VBoxContainer/ScrollContainer/CraftableItemsContainer
=======
@export var type = "Hand"

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var crafting_buttons_container: GridContainer = $VBoxContainer/MarginContainer/CraftingButtonsContainer
>>>>>>> Stashed changes

func get_all_items_in_inv():
	var result: Dictionary = {}
	
	for i in player.inventory:
		if i == null:
			continue
		if result.get(i.type) == null: result[i.type] = 0
		result[i.type] += i.amount
	
	return result

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
func get_all_craftable_items():
	var all_items: Dictionary = get_all_items_in_inv()

	var valid_items := []
<<<<<<< Updated upstream
	for item in item_recipes:
		var ingredients = item_recipes[item].Ingredients
=======
	for item in Main.item_recipes:
		var ingredients = Main.item_recipes[item].Ingredients
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
		for child in craftable_items_container.get_children():
			child.queue_free()
		return
	
	for i in get_all_craftable_items():
		var slot = preload("res://UI/InventorySlot.tscn").instantiate()
		slot.icon = Item.item_types[i]["Sprite"]
		craftable_items_container.add_child(slot)
=======
		for child in crafting_buttons_container.get_children():
			child.queue_free()
		return
	
	for i in Main.item_recipes:
		var slot = preload("res://UI/CraftingMenuButton.tscn").instantiate()
		slot.type = i
		
		if not get_all_craftable_items().has(i):
			slot.disabled = true
		
		crafting_buttons_container.add_child(slot)
>>>>>>> Stashed changes
