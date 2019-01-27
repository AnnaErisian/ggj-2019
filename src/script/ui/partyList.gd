extends ItemList

const TOTAL_WIDTH = 15

func loadParty():
	clear()
	
	add_item("Party:", null, false)
	
	MainData.party.sort()
	var activeCharacters = MainData.party.active
	
	for character in activeCharacters:
		add_item(str(character.name))
	
