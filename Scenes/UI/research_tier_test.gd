extends Control
@onready var research_tier_test: Control = $"."

const SKILL_BUTTON = preload("uid://ynrmosy74ech")
const BUTTON_WIDTH = 250
const TIER_VERTICAL_SPACING = 100  # space between tiers
const HORIZONTAL_SPACING = 20      # space between buttons horizontally

func _ready() -> void:
	var skill_tree = Globals.skill_trees["fire_fighter_tree"]
	var tiers := {}
	for skill in skill_tree:
		var tier = skill["tier"]
		if not tiers.has(tier):
			tiers[tier] = []
		tiers[tier].append(skill)
		
	for tier in tiers.keys():
		var skills_in_tier = tiers[tier]
		var count = skills_in_tier.size()
		var total_width = count * BUTTON_WIDTH + (count - 1) * HORIZONTAL_SPACING
		var start_x = -total_width / 2
		for index in range(count):
			var skill = skills_in_tier[index]
			var newSkill_Button = SKILL_BUTTON.instantiate()
			newSkill_Button.title = skill["title"]
			newSkill_Button.description = skill["description"]
			newSkill_Button.price = skill["price"]
			for root in skill["root"]:
				print (root)
			newSkill_Button.root = skill["root"]
			# 3. Compute position
			var x = start_x + index * (BUTTON_WIDTH + HORIZONTAL_SPACING)
			var y = (tier - 1) * TIER_VERTICAL_SPACING + 50
			newSkill_Button.position = Vector2(x, y)
			research_tier_test.add_child(newSkill_Button)
