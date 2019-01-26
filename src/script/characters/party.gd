class party:
	var maxParty = 40
	
	var active = []
	var inactive = []
	
	func _init(characters):
		inactive = characters
		
	func setActive(member):
		if inactive.has(member) && active.size < (maxParty - 1):
			inactive.remove(member)
			active.append(member)
		
	func setInactive(member):
		if active.has(member) && active.size() > 1 && !member.isPlayer():
			active.remove(member)
			inactive.add(member)
		
	func sort():
		active.sort_custom(Party, "partySort")
		inactive.sort_custom(Party, "partySort")
		
	func partySort(a, b):
		if a.getName() < b.getName():
			return true
		return false