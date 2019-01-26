extends Node

const Party = preload("res://src/script/characters/party.gd")
const Character = preload("res://src/script/characters/character.gd")
const Skill = preload("res://src/script/characters/skill.gd")

func listParty(p):
	print("#########")
	print("Active:")
	for member in p.active:
		print(member.name)
	print("---------")
	print("Inactive:")
	for member in p.inactive:
		print(member.name)


func _ready():
	# to do
	var skone = Skill.skill.new("sk1", "desc1", "things", 112)
	var sktwo = Skill.skill.new("sk2", "desc2", "things", 382)
	var a = Character.character.new("a", [skone, sktwo], 0, true)
	var b = Character.character.new("b", [skone, sktwo], 250)
	var c = Character.character.new("c", [skone, sktwo], 350)
	var d = Character.character.new("d", [skone, sktwo], 450)
	
	var p = Party.party.new([a, b, c, d])
	
	var e = Character.character.new("e", [skone, sktwo], 450)
	var f = Character.character.new("f", [skone, sktwo], 450)
			
	
	
	print("******************TEST*******************")
	for skillName in p.skillList.keys():
		print(skillName + ": " + p.skillList[skillName].description + " - " + p.skillList[skillName].resource)
	
	listParty(p)
	p.setInactive(a)
	listParty(p)
	p.setInactive(b)
	listParty(p)
	p.addMember(e)
	listParty(p)
	p.setActive(e)
	listParty(p)
	p.addMember(f)
	p.setActive(f)
	listParty(p)
	p.setActive(b)
	listParty(p)
	print(p.skillTotals())
	
	print("##################")
	var t = p.newCharacter("test", ["Leadership", "Forestry"])
	p.setActive(t)
	listParty(p)
	print(p.skillTotals())