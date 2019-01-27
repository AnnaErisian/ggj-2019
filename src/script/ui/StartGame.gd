extends Button

var Party = preload("res://src/script/characters/party.gd")



func _pressed():
	initParty()
	
	get_tree().change_scene("res://src/scene/Main.tscn")
	
func initParty():
	var party = Party.party.new()
	initChar(party, "../PlayerInit", true)
	initChar(party, "../Family Create 1", false)
	initChar(party, "../Family Create 2", false)
	initChar(party, "../Family Create 3", false)
	MainData.party = party
	
	
func initChar(party, node, player):
	var name = get_node(node + "/Name").text
	var skillsIndex = get_node(node + "/Job").get_selected_items()
	var jobValues = JobLoader.jobs.values()
	if skillsIndex.size() == 0:
		randomize()
		skillsIndex = [randi()% jobValues.size()]
	var skills = jobValues[skillsIndex[0]]
	
	var character = party.newCharacter(name, skills)

	if player:
		character.isPlayer = true
		party.player = character
		character.skills.append(SkillLoader.newSkill("Leadership"))
	else:
		character.relationshipToPlayer = get_node(node + "/Relationship")
	for skill in character.skills:
		skill.xp = 100
	if player:
		for skill in SkillLoader.skills:
			if !(skill in skills):
				character.skills.append(SkillLoader.newSkill(skill))
	party.setActive(character)