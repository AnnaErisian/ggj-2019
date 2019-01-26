class character:
	const Schedule = preload("res://src/script/mechanics/schedule.gd")
	const Obligation = preload("res://src/script/mechanics/obligation.gd")
	const Skill = preload("res://src/script/characters/skill.gd")
	
	const bond_level_xp = 100
	
	var name = ""
	
	var inParty = false
	var homeLocation = ""
	
	var skills = []
	
	var bondXp = 0
	
	var desiredResource = ""
	
	var schedule = Schedule.schedule.new()
	
	var isPlayer = false
	
	func _init(charName, player, skillList, bond):
		skills = skillList
		isPlayer = player
		bondXp = bond
		name = charName
	
	func bondLevel():
		return bondXp / bond_level_xp