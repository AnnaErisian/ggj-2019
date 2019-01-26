extends Node

const Character = preload("res://src/script/characters/character.gd")
const Skill = preload("res://src/script/characters/skill.gd")

const SkLoader = preload("res://src/script/characters/skillLoader.gd")

func _ready():
	
	var loader = SkLoader.skillLoader.new()
	loader.loadSkills()
	
	var forestry = loader.newSkill("Forestry")
	var hunting = loader.newSkill("Hunting")
	forestry.xp = 200
	
	var c = Character.character.new("a", [forestry, hunting], 150, true)
	
	
	print("******************TEST*******************")
	print(c.name)
	print("Player: " + str(c.isPlayer))
	
	for skill in c.skills:
		print(skill.name + " -- " + skill.description + ", lv: " + str(skill.level()) + ", XP: " + str(skill.xp))
	print("Bond level: " + str(c.bondLevel()) + ", XP: " + str(c.bondXp))
	
	print("----------------------------------------")
	print("Set desired resource")
	var n = 0
	while n < 20:
		c.setResource(5, loader.skills, randi()%10+1)
		print("Resource: " + str(c.desiredResource))
		n += 1