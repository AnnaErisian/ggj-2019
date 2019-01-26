class event:
	var name = ""
	var description = ""
	var time = 0
	
	var options = {}
	var checks = {}
	
	# params: skill[] partySkills
	func checkChecks(partySkills):
		var failedChecks = {}
		for skillToCheck in checks.Keys():
			var target = checks[skillToCheck]
			var current = 0
			for skill in partySkills:
				if skill.name == skillToCheck:
					current += skill.level
			
			var difference = current - target
			if difference < 0:
				failedChecks[skillToCheck] = difference
		
		return failedChecks
	
	