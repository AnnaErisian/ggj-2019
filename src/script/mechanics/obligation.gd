class obligation:
	var startTime = 0
	var endTime = 0
	
	func _init(start, end):
		startTime = start
		endTime = end
	
	# params: Obligation obligation
	func equals(obligation):
		if startTime == obligation.startTime && endTime == obligation.endTime:
			return true
		return false
