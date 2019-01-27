extends Panel


func loadLists():
	var active = get_node("ActiveParty")
	var inactive = get_node("InactiveParty")
	var resources = get_node("ResourcesList")
	
	active.clear()
	inactive.clear()
	resources.clear()
	
	# Loads active party
	for member in MainData.party.active:
		Logger.write(member.name)
		var listStr = member.name + " - " + "Bond: " + str(member.bondLevel()) + " - "
		var skillStr = ""
		var index = 0
		for skill in member.skills:
			skillStr += skill.name + ": " + str(skill.level())
			index += 1
			if index < member.skills.size():
				skillStr += ", "
		listStr += skillStr
		active.add_item(listStr)
		
	# Loads inactive party
	for member in MainData.party.inactive:
		Logger.write(member.name)
		var listStr = member.name + " - " + "Bond: " + str(member.bondLevel()) + " - "
		var skillStr = ""
		var index = 0
		for skill in member.skills:
			skillStr += skill.name + ": " + str(skill.level())
			index += 1
			if index < member.skills.size():
				skillStr += ", "
		listStr += skillStr
		inactive.add_item(listStr)
		
	for resource in MainData.party.resources:
		var resourceStr = resource + ": " + str(MainData.party.resources[resource])
		resources.add_item(resourceStr)
		
func setInactive():
	var active = get_node("ActiveParty")
	var selectedMember = active.get_selected_items()

	
	