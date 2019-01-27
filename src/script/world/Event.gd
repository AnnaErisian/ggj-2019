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
			var target = checks[skillToCheck]
			var current = partySkills[skillToCheck]
			
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
		