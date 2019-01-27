extends Node

var jobs = {}

func _init():
	var file = File.new()
	file.open("res://assets/data/jobs.json", file.READ)
	var json = file.get_as_text()
	var jsonresult = JSON.parse(json)
	file.close()
	
	for result in jsonresult.get_result().keys():
		parseJob(jsonresult.get_result()[result])

# params: dictionary skill
func parseJob(job):
	jobs[job.name] = job.skills
	#kills[skillToAdd.name] = skillToAdd