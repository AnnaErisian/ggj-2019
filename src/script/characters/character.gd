const Schedule = preload("res://src/script/mechanics/schedule.gd")
const Obligation = preload("res://src/script/mechanics/obligation.gd")

var name = ""

var inParty = false
var homeLocation = ""

var skills = {}
var bondLevel = 0
var bondXp = 0

var desiredResource = ""

var schedule = Schedule.new()
