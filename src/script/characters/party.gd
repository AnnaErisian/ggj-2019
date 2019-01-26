const Character = preload("res://src/script/characters/character.gd")
const SkillLoader = preload("res://src/script/characters/skillLoader.gd")
const Skill = preload("res://src/script/characters/skill.gd")

class party:
	# List of all possible skill objects, initialized at 0
	var skillList = {}
	
	var skillLoader = null
	
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
	func _init(characters):
		skillLoader = SkillLoader.skillLoader.new()
		skillLoader.loadSkills()
		skillList = skillLoader.skills
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

	# Sets an active party member to inactive. Leader must always remain in party.
	func setInactive(member):
		if active.has(member) && active.size() > 1:
			if member.isPlayer:
				print("You can't remove your party leader")
			else:
				active.remove(active.find(member))
				inactive.append(member)
				sort()

	# Adds a new character to the party. Default inactive.
	func addMember(member):
		inactive.append(member)
		sort()
		
	# Creates a new character with the given name
	# and skills
	func newCharacter(name, skillNames=[]):
		var skills = []
		for skName in skillNames:
			var skill = skillLoader.newSkill(skName)
			skills.append(skill)
		var c = Character.character.new(name, skills, 0)
		addMember(c)
		return c
		
	# Finds a character by name and returns an object
	# for that character
	func findCharacter(name):
		pass
	
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
		active.sort()
		inactive.sort()
		active.remove(active.find(player))
		active.push_front(player)
	#	active.sort_custom(p, "partySort")
	#	inactive.sort_custom(p, "partySort")
		
	# Sorting is hard
	func partySort(a, b):
		if a.name < b.name:
			return true
		return false
		