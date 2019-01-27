extends Panel


func _ready():
	for key in JobLoader.jobs.keys():
		get_node("Job").add_item(key + ": " + str(JobLoader.jobs[key]))