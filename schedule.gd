const Obligation = preload("res://obligation.gd")

var obligations = []
var requestedTime = null
var currentTime = 0

# params: int currTime
func update(currTime):
	currentTime = currTime
	var toRemove = []
	for obligation in obligations:
		if obligation.endTime < currTime:
			toRemove.append(obligation)
	for obligation in toRemove:
		obligations.remove(obligation)

# params: Obligation obligation
func addObligation(obligation):
	var conflicts = {}
	addConflicts(conflicts, obligation)
	if conflicts.empty():
		obligations.append(obligation)
		return 0
	return -1

# params: Obligation request, int bondLevel, int currTime
func requestTime(request, bondLevel, currTime):
	var initialObligations = obligations.copy()
	currentTime = currTime
	
	var conflicts = {}
	addConflicts(conflicts, request)
	if conflicts.empty():
		requestedTime = request
		return 0
	
	var direction = 0
	while conflicts.size() > 0:
		direction = resolveConflict(conflicts, direction, bondLevel)
		if direction == null:
			obligations = initialObligations.copy()
			return -1
	return 0

# params: Obligation[] conflicts, Obligation request
func addConflicts(conflicts, request):
	for obligation in obligations:
		if (request.startTime > obligation.startTime && request.startTime < obligation.endTime) || (request.endTime > obligation.startTime && request.endTime < obligation.endTime) || (request.startTime < obligation.startTime && request.endTime > obligation.endTime):
			if !conflicts.has(obligation):
				conflicts[obligation] = request

# params: Obligation[] conflicts, int direction, int bondLevel
# TODO: lookup bond level
func resolveConflict(conflicts, direction, bondLevel):
	var conflict = conflicts.keys[0]
	var request = conficts[conflict]
	
	if direction == 0:
		var posDifference = request.endTime - conflict.startTime
		var negDifference = conflict.endTime - request.startTime
		if posDifference <= negDifference:
			direction = 1
		else:
			direction = -1
	
	if direction == 1:
		var difference = request.endTime - conflict.startTime
		if difference > bondLevel:
			return null
			
		conflicts.erase(conflict)
		obligations.remove(conflict)
		conflict.startTime += difference
		conflict.endTime += difference
		obligations.append(conflict)
		conflicts.addConflicts(conflicts, conflict)
		
	elif direction == -1:
		var difference = conflict.endTime - request.startTime
		if difference > bondLevel:
			return null
		if conflict.startTime - difference < currentTime:
			return null
		
		conflicts.erase(conflict)
		obligations.remove(conflict)
		conflict.startTime -= difference
		conflict.endTime -= difference
		obligations.append(conflict)
		conflicts.addConflicts(conflicts, conflict)
		
	return direction
		
		
		
		
		