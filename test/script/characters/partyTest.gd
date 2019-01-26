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
	var skone = Skill.skill.new("sk1", "desc1", 12)
	var sktwo = Skill.skill.new("sk2", "desc2", 382)
	var a = Character.character.new("a", true, [skone, sktwo], 150)
	var b = Character.character.new("b", false, [skone, sktwo], 250)
	var c = Character.character.new("c", false, [skone, sktwo], 350)
	var d = Character.character.new("d", false, [skone, sktwo], 450)
	
	var p = Party.party.new([a, b, c, d])
	
	var e = Character.character.new("e", false, [skone, sktwo], 450)
	var f = Character.character.new("f", false, [skone, sktwo], 450)
			
	
	
	print("******************TEST*******************")
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