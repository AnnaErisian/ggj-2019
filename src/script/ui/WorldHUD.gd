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
	party = Party.party.new([player])
	
	get_node("partyList").margin_bottom = OS.get_real_window_size().y / 2
	get_node("skillList").margin_top = OS.get_real_window_size().y / 2 * -1
	get_node("skillList").loadSkills(party)

