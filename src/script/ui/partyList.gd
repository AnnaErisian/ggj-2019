extends ItemList

const TOTAL_WIDTH = 15

# params: Party party
func loadParty(party):
	add_item("Party:", null, false)
	
	var activeCharacters = party.active
	var inactiveCharacters = party.inactive
	
	for character in activeCharacters:
		add_item(character.name)
	
	for character in inactiveCharacters:
		add_item(character.name)
