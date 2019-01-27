extends ItemList

const TOTAL_WIDTH = 15

func loadSkills():
	clear()
	
	add_item("Skill Totals:", null, false)
	
	var activeSkills = MainData.party.skillTotals()
	
	for skillName in activeSkills.keys():
		var skillNameLength = skillName.length()
		add_item(skillName + ":%*d" % [TOTAL_WIDTH - skillNameLength, activeSkills[skillName]])
