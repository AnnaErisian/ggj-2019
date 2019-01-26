

class skill:
	const xp_to_level = 100
	
	var name = ""
	var description = ""
	var resource = ""
	
	var xp = 0
	
	func _init(skillName, skillDescription, resourceCollected, baseXp):
		name = skillName
		description = skillDescription
		xp = baseXp
		resource = resourceCollected
	
	func level():
		return xp / 100
	