const Skill = preload("res://src/script/characters/skill.gd")

class skillLoader:
	var skills = {}
	
	func loadSkills():
		var file = File.new()
		file.open("res://assets/data/skills.json", file.READ)
		var json = file.get_as_text()
		var jsonresult = JSON.parse(json)
		file.close()
		
		for result in jsonresult.get_result().keys():
			parseSkill(jsonresult.get_result()[result])
	
	# params: dictionary skill
	func parseSkill(skill):
		var skillToAdd = Skill.skill.new(skill["name"], skill["description"], 0)
		
		skills[skillToAdd.name] = skillToAdd