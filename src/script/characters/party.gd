
const Character = preload("res://src/script/characters/character.gd")

class party:
	var maxParty = 5
	
	var active = []
	var inactive = []
	
	var player = null
	
	func _init(characters):
		active = characters
		for c in characters:
			if c.isPlayer:
				player = c
		sort()
		
	func setActive(member):
		if inactive.has(member):
			if active.size() >= maxParty:
				print("Party is too large")
			else:
				inactive.remove(inactive.find(member))
				active.append(member)
				sort()

		
	func setInactive(member):
		if active.has(member) && active.size() > 1:
			if member.isPlayer:
				print("You can't remove your party leader")
			else:
				active.remove(active.find(member))
				inactive.append(member)
				sort()

		
	func addMember(member):
		inactive.append(member)
		sort()
		
	func skillTotals():
		var totals = {}
		for member in active:
			for skill in member.skills:
				if totals.has(skill.name):
					totals[skill.name] += skill.level()
				else:
					totals[skill.name] = skill.level()
		return totals
		
	func sort():
		active.sort()
		inactive.sort()
		active.remove(active.find(player))
		active.push_front(player)
	#	active.sort_custom(p, "partySort")
	#	inactive.sort_custom(p, "partySort")
		
	func partySort(a, b):
		if a.name < b.name:
			return true
		return false
		