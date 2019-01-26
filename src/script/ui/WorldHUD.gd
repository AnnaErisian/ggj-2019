extends Control

const Party = preload("res://src/script/characters/party.gd")
const Character = preload("res://src/script/characters/character.gd")
const Skill = preload("res://src/script/characters/skill.gd")

var player
var party

func _ready():
	var tempSkill = Skill.skill.new("tempSkill", "for testing", "some resource", 0)
	var tempSkill2 = Skill.skill.new("tempSkill2", "for testing", "some resources", 2)
	player = Character.character.new("Player", [tempSkill, tempSkill2], 0, true)
	var char1 = Character.character.new("Char 1", [tempSkill, tempSkill2], 0, true)
	var char2 = Character.character.new("Char 2", [tempSkill, tempSkill2], 0, true)
	party = Party.party.new([player, char1, char2])
	
	var windowHeight = OS.get_real_window_size().y - 40
	get_node("partyList").margin_bottom = windowHeight / 2
	get_node("partyList").loadParty(party)
	get_node("skillList").margin_top = windowHeight / 2 * -1
	get_node("skillList").loadSkills(party)
	
	get_node("currTime").text = str(get_tree().get_root().get_node("Main").get_node("MainData").currTime)

