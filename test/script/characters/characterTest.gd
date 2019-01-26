extends Node

const Character = preload("res://src/script/characters/character.gd")
const Skill = preload("res://src/script/characters/skill.gd")

func _ready():
	
	var skone = Skill.skill.new("sk1", "desc1", 12)
	var sktwo = Skill.skill.new("sk2", "desc2", 382)
	var c = Character.character.new("one", true, [skone, sktwo], 150)
	
	
	print("******************TEST*******************")
	print(c.name)
	print("Player: " + str(c.isPlayer))
	
	for skill in c.skills:
		print(skill.name + " -- " + skill.description + ", lv: " + str(skill.level()) + ", XP: " + str(skill.xp))
	print("Bond level: " + str(c.bondLevel()) + ", XP: " + str(c.bondXp))
	
	