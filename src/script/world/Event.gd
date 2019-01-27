extends Node

const Character = preload("res://src/script/characters/character.gd")

class event:
	var name = ""
	var description = ""
	var time = 0
	
	var eventColor
	var eventType
	
	var eventImmediate = false
	
	var internal = false
	
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
				elif skillToCheck.substr(5,9) == "NINPARTY-" :
					var member = MainData.party.findCharacter(skillToCheck.substr(14,100))
					if typeof(member) == TYPE_OBJECT:
						failedChecks[skillToCheck] = 1
				elif skillToCheck.substr(5,12) == "CANACTIVATE-" :
					var member = MainData.party.findCharacter(skillToCheck.substr(17,100))
					if MainData.party.active.has(member):
						failedChecks[skillToCheck] = 1
				elif skillToCheck.substr(5,7) == "ACTIVE-" :
					var member = MainData.party.findCharacter(skillToCheck.substr(12,100))
					if !MainData.party.active.has(member):
						failedChecks[skillToCheck] = 1
			elif skillToCheck.substr(0,5) == "ITEM-" :
				if skillToCheck.substr(5,4) == "HAS-" :
					var itemName = skillToCheck.substr(9,1000)
					#print("Checking if we have %d %s (we have %s)" % [checks[skillToCheck], itemName, MainData.party.resources[itemName]])
					if MainData.party.resources.has(itemName) and MainData.party.resources[itemName] >= checks[skillToCheck]:
						pass
					else:
						failedChecks[skillToCheck] = 1
				if skillToCheck.substr(5,6) == "LACKS-" :
					var itemName = skillToCheck.substr(11,1000)
					#print("Checking if we lack %d %s (we have %s)" % [checks[skillToCheck], itemName, MainData.party.resources[itemName]])
					if !MainData.party.resources.has(itemName) or MainData.party.resources[itemName] < checks[skillToCheck]:
						pass
					else:
						failedChecks[skillToCheck] = 1
			else:
				var target = checks[skillToCheck]
				var current = 0
				if partySkills.has(skillToCheck.capitalize()) :
					current = partySkills[skillToCheck.capitalize()]
				
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
				if result.substr(0,8) == "additem-":
					addItems(result.substr(8,100), value)
				if result.substr(0,11) == "removeitem-":
					removeItems(result.substr(11,100), value)
				elif result == "relationship":
					addRelationship(value)
				elif result == "time":
					addTime(value)
	
	func addExperience(skill,value):
		for npc in MainData.party.active:
			if(npc.skills.has(skill)):
				npc.skills[skill].xp += value
		
	func addNewCharacter(chardata):
		var skills = chardata['skills']
		var skillObjs = []
		for skill in skills:
			var ns = SkillLoader.newSkill(skill.capitalize())
			ns.xp = 100*skills[skill]
			skillObjs.append(ns)
		var newb = Character.character.new(chardata['name'], skillObjs, chardata['initialBond'])
		MainData.party.addMember(newb)
		if chardata.has('immediatelyActive'):
			print("activating new party member immediately")
			MainData.party.setActive(newb)
			
	
	func activateCharacter(name):
		MainData.party.setActive(MainData.party.findCharacter(name))
	
	func deactivateCharacter(name):
		MainData.party.setInactive(MainData.party.findCharacter(name))
		
	func addItems(name, number):
		Logger.write("Gained %d %s" % [number, name])
		if(number<0):
			removeItems(name,number*-1)
		else:
			MainData.party.addItems(name,number)
		
	func removeItems(name, number):
		Logger.write("Lost %d %s" % [number,name])
		MainData.party.removeItems(name,number)
	
	func addRelationship(value):
		Logger.write("Everyone gained %d relationship" % [value])
		for npc in MainData.party.active:
			npc.bondXp += value
	
	func addTime(value):
		MainData.addTime(value)
		