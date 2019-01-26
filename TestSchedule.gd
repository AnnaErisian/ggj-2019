extends Node2D

const Schedule = preload("res://schedule.gd")
const Obligation = preload("res://obligation.gd")

func _ready():
	var s = Schedule.schedule.new()
	var obsToAdd = []
	obsToAdd.append(Obligation.obligation.new(1, 4))
	obsToAdd.append(Obligation.obligation.new(7, 10))
	obsToAdd.append(Obligation.obligation.new(25, 40))
	obsToAdd.append(Obligation.obligation.new(42, 52))
	obsToAdd.append(Obligation.obligation.new(6, 8))
	
	for obs in obsToAdd:
		s.addObligation(obs)
	
	s.requestTime(Obligation.obligation.new(20, 29), 5, 0)
	
	print("******************TEST*******************")
	print(s.obligations.size())
	for obligation in s.obligations:
		print("Start: " + str(obligation.startTime) + ", End: " + str(obligation.endTime))
	if s.requestedTime != null:
		print("Requested Time")
		print("Start: " + str(s.requestedTime.startTime) + ", End: " + str(s.requestedTime.endTime))