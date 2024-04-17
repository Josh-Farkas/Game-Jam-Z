extends PanelContainer

@export var result = "";
var recipe

var ingredient_info: PackedScene = load("res://UI/CraftingIngredientInfo.tscn")

func _ready():
	set_recipe(result)

func _process(delta):
	global_position = get_global_mouse_position() + Vector2(32,32)
	
func set_recipe(result: String):
	recipe = Main.item_recipes[result]
	
	for ingredient in recipe.Ingredients.keys():
		
		var ingredient_info_instance = ingredient_info.instantiate()
		ingredient_info_instance.get_node("CraftingPanelButton").type = ingredient
		ingredient_info_instance.get_node("Label").text = str(recipe.Ingredients[ingredient]) + " x " + ingredient
		$MarginContainer/VBoxContainer/Label.text = result
		$MarginContainer/VBoxContainer.add_child(ingredient_info_instance)
