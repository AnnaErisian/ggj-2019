const Character = preload("res://src/script/characters/character.gd")
const Skill = preload("res://src/script/characters/skill.gd")

class party:
	
	signal party_updated
	
	var maxParty = 50
	
	# List of active and inactive party members
	var active = []
	var inactive = []
	
	var currentLocation = ""
	
	# Dict mapping resources names to quantity possessed
	var resources = {}
	
	# Reference to the player character
	var player = null
	
	# Initializes the party, all characters passed in here will start active.
	func _init(characters=[]):
		active = characters
		for c in characters:
			if c.isPlayer:
				player = c
		sort()
		
	# Sets an inactive party member active. Limited by max party size.
	func setActive(member):
		if inactive.has(member):
			if active.size() >= maxParty:
				print("Party is too large")
			else:
				inactive.remove(inactive.find(member))
				active.append(member)
				sort()
			emit_signal("party_updated")

	# Sets an active party member to inactive. Leader must always remain in party.
	func setInactive(member):
		if active.has(member) && active.size() > 1:
			if member.isPlayer:
				print("You can't remove your party leader")
			else:
				active.remove(active.find(member))
				inactive.append(member)
				sort()
			emit_signal("party_updated")

	# Adds a new character to the party. Default inactive.
	func addMember(member):
		inactive.append(member)
		sort()
		
	# Creates a new character with the given name
	# and skills
	func newCharacter(name, skillNames=[]):
		var skills = []
		for skName in skillNames:
			var skill = SkillLoader.newSkill(skName)
			skills.append(skill)
		var c = Character.character.new(name, skills, 0)
		addMember(c)
		return c
		
	# Finds a character by name and returns an object
	# for that character
	func findCharacter(name):
		for character in active:
			print(character.name)
			if character.name == name:
				return character
		for character in inactive:
			print(character.name)
			if character.name == name:
				return character
		return false
	
	# Returns a dict mapping skill names to total
	# levels among active party members
	func skillTotals():
		var totals = {}
		for member in active:
			for skill in member.skills:
				if totals.has(skill.name):
					totals[skill.name] += skill.level()
				else:
					totals[skill.name] = skill.level()
		return totals
		
	# Sorts both active and inactive lists.
	# Party leader must remain in front of the active list.
	func sort():
		insertionSort(active)
		insertionSort(inactive)
		
		if player != null:
			active.remove(active.find(player))
			active.push_front(player)
		
	# params: Character[] arr
	func insertionSort(arr):
		var tempArr = arr.duplicate()
		arr.clear()
		
		while tempArr.size() > 0:
			var tempChar = tempArr.pop_front()
			var idx = 0
			while idx < arr.size():
				if tempChar.name < arr[idx].name:
					break
				idx += 1
			arr.insert(idx, tempChar)
	
	func addItems(name, number):
		if(resources.has(name)):
			resources[name] += number
		else:
			resources[name] = number
	
	func removeItems(name, number):
		if(resources.has(name)):
			if resources[name] > number:
				#more than enough
				resources[name] -= number
				return true
			elif resources[name] == number:
				#just enough
				resources.erase(name)
				return true
			else:
				#we dont have that many 
				resources.erase(name)
				return false
		else:
			return false
		
		