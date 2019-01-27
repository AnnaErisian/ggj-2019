const Character = preload("res://src/script/characters/character.gd")
const Skill = preload("res://src/script/characters/skill.gd")

class event:
	var name = ""
	var description = ""
	var time = 0
	
	var options = {}
	var checks = {}
	
	func _init():
		pass
	
	# params: dictionary partySkills
	func checkChecks(partySkills):
		var failedChecks = {}
		for skillToCheck in checks.keys():
			if skillToCheck.substr(0,5) == "SPEC-" :
				if skillToCheck.substr(5,8) == "INPARTY-" :
					var member = MainData.party.findCharacter(skillToCheck.substr(13,100))
					if member:
						pass
					else:
						failedChecks[skillToCheck] = 1
				elif skillToCheck.substr(5,7) == "ACTIVE-" :
					var member = MainData.party.findCharacter(skillToCheck.substr(12,100))
					if !MainData.party.active.has(member):
						failedChecks[skillToCheck] = 1
				elif skillToCheck.substr(5,9) == "INACTIVE-" :
					var member = MainData.party.findCharacter(skillToCheck.substr(14,100))
					if !MainData.party.inactive.has(member):
						failedChecks[skillToCheck] = 1
			else:
				var target = checks[skillToCheck]
				var current = 0
				if partySkills.has(skillToCheck) :
					current = partySkills[skillToCheck]
				
				var difference = current - target
				if difference < 0:
					failedChecks[skillToCheck] = difference
		
		return failedChecks
	
	# params: string option, dictionary partySkills
	func selectOption(option, partySkills):
		if !options.has(option):
			return "Invalid option"
		checks = options[option]["checks"]
		var failures = checkChecks(partySkills)
		if failures.empty():
			return options[option]["success"]
		return options[option]["failure"]
		
		
	func applyResults(results):
		for result in results:
			if result == "text":
				pass
			else:
				var value = results[result]
				if result.substr(0,3) == "xp-":
					var skill = result.substr(3,100)
					addExperience(skill, value)
				if result.substr(0,5) == "join":
					addNewCharacter(value)
				if result.substr(0,9) == "activate-":
					activateCharacter(result.substr(9,100))
				if result.substr(0,11) == "deactivate-":
					deactivateCharacter(result.substr(11,100))
				elif result == "relationship":
					addRelationship(value)
				elif result == "time":
					addTime(value)
	
	func addExperience(skill,value):
		for npc in MainData.party.active:
			if(npc.skills.has(skill)):
				npc.skills[skill].xp += value
		
	func addNewCharacter(chardata):
		var newb = Character.character.new(chardata['name'], chardata['skills'], chardata['initialBond'])
		MainData.party.addMember(newb)
		if chardata.has('immediatelyActive') and chardata['immediatelyActive']!="false":
			MainData.party.setActive(newb)
			
	
	func activateCharacter(name):
		MainData.party.setActive(MainData.party.findCharacter(name))
	
	func deactivateCharacter(name):
		MainData.party.setInactive(MainData.party.findCharacter(name))
	
	func addRelationship(value):
		for npc in MainData.party.active:
			npc.bondXp += value
	
	func addTime(value):
		MainData.addTime(value)
		