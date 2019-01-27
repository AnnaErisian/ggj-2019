extends ItemList

const TOTAL_WIDTH = 15

func loadParty():
	add_item("Party:", null, false)
	
	var activeCharacters = MainData.party.active
	
	for character in activeCharacters:
		add_item(character.name)
	
