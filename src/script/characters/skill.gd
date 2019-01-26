class skill:
	const xp_to_level = 100
	
	var name = ""
	var description = ""
	
	var xp = 0
	
	func _init(skillName, skillDescription, baseXp):
		name = skillName
		description = skillDescription
		xp = baseXp
	
	func level():
		return xp / 100