extends ItemList

const TOTAL_WIDTH = 15

# params: Party party
func loadSkills(party):
	add_item("Skill Totals:", null, false)
	
	var activeSkills = party.skillTotals()
	
	for skillName in activeSkills.keys():
		var skillNameLength = skillName.length()
		add_item(skillName + ":%*d" % [TOTAL_WIDTH - skillNameLength, activeSkills[skillName]])
