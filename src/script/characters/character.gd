class character:
	const Schedule = preload("res://src/script/mechanics/schedule.gd")
	const Obligation = preload("res://src/script/mechanics/obligation.gd")
	const Skill = preload("res://src/script/characters/skill.gd")
	
	const bond_level_xp = 100
	
	var name = ""
	
	var inParty = false
	var homeLocation = ""
	var currentLocation = ""
	
	var skills = []
	
	var bondXp = 0
	
	var desiredResource = {}
	
	var schedule = Schedule.schedule.new()
	
	var isPlayer = false
	
	# Inits a character with a name, skills, and bond level.
	# 'player' specifies is this is the player character and
	# will default to false.
	func _init(charName, skillList, bond, player=false):
		skills = skillList
		isPlayer = player
		bondXp = bond
		name = charName
	
	# Returns the character's bond level with the player
	func bondLevel():
		return bondXp / bond_level_xp
		
	# Randomly sets a resource for the character to want.
	# Weights against resources assigned to skills the
	# character has 
	func setResource(weight, list, quantity, replace=true):
		if replace:
			desiredResource.clear()
		var charSkNames = {}
		for skill in skills:
			charSkNames[skill.name] = skill.level()
		var select = []
		for skillName in list:
			var n = 0
			if charSkNames.keys().has(skillName):
				n += charSkNames[skillName]
			while n < weight:
				if list[skillName].resource != "":
					select.append(list[skillName].resource)
				n += 1
		var length = select.size()
		var rand = randi()%length
		var resource = select[rand]
		if resource in desiredResource.keys():
			desiredResource[resource] += quantity
		else:
			desiredResource[resource] = quantity
	
	func learnSkill(skill):
		skills.append(skill)
		