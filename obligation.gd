var startTime = 0
var endTime = 0

# params: Obligation obligation
func equals(obligation):
	if startTime == obligation.startTime && endTime == obligation.endTime:
		return true
	return false
