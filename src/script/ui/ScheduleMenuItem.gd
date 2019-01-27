extends Control

# params: Character character
func loadCharacterData(character):
	get_node("name").text = character.name
	print("Loaded " + character.name)