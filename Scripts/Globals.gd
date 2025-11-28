extends Node

var day=0
var month=0
var funds=0
var trustFactor=0
var skill_trees = load_skill_trees()

func _ready() -> void:
	print (skill_trees["fire_fighter_tree"])
	for skill in skill_trees["fire_fighter_tree"]:
		print (skill["title"])

func load_skill_trees() -> Dictionary:
	var file = FileAccess.open("res://saves/skill_tree.json", FileAccess.READ)
	var content = file.get_as_text()
	print (content)
	return JSON.parse_string(content)
