extends Control

const Party = preload("res://src/script/characters/party.gd")
const Character = preload("res://src/script/characters/character.gd")
const Skill = preload("res://src/script/characters/skill.gd")
const Schedule = preload("res://src/script/mechanics/schedule.gd")
const Obligation = preload("res://src/script/mechanics/obligation.gd")



var player
var party

func _ready():
	MainData.connect("time_updated", self, "on_timeUpdated")
	
	#TODO: remove temporary testing data
	var tempSkill = Skill.skill.new("tempSkill", "for testing", "some resource", 0)
	var tempSkill2 = Skill.skill.new("tempSkill2", "for testing", "some resources", 2)
	player = Character.character.new("Player", [tempSkill, tempSkill2], 2400, true)
	var char1 = Character.character.new("Char 1", [tempSkill, tempSkill2], 0, true)
	var char2 = Character.character.new("Char 2", [tempSkill, tempSkill2], 0, true)
	
	player.schedule = Schedule.schedule.new()
	var obsToAdd = []
	obsToAdd.append(Obligation.obligation.new(50, 100))
	obsToAdd.append(Obligation.obligation.new(7, 10))
	obsToAdd.append(Obligation.obligation.new(270, 295))
	obsToAdd.append(Obligation.obligation.new(200, 250))
	obsToAdd.append(Obligation.obligation.new(6, 8))
	
	for obs in obsToAdd:
		player.schedule.addObligation(obs)
	
	
	party = Party.party.new([player, char1, char2])
	MainData.party = party
	print(party.active)
	
	get_node("lists/partyList").loadParty(party)
	get_node("lists/skillList").loadSkills(party)
	
	get_node("currTime").text = str(MainData.currTime)

func on_timeUpdated():
	get_node("currTime").text = str(MainData.currTime)
	