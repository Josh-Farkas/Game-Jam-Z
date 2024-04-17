extends PanelContainer

@export var result = "";
var recipe

func _ready():
	set_recipe(result)

func _process(delta):
	global_position = get_global_mouse_position() + Vector2(32,32)
	
func set_recipe(result: String):
	recipe = Main.item_recipes[result]
	
	for ingredient in recipe.Ingredients.keys():
		var ingredient_info = preload("res://UI/CraftingIngredientInfo.tscn").instantiate()
		print(ingredient_info.get_children())
		ingredient_info.get_node("CraftingPanelButton").type = ingredient
		ingredient_info.get_node("Label").text = str(recipe.Ingredients[ingredient]) + " x " + ingredient
		$VBoxContainer.add_child(null)
