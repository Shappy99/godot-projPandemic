extends Button
class_name SkillNode
@onready var texture_rect: TextureRect = $TextureRect
@onready var color_rect: ColorRect = $ColorRect
@onready var price_label: Label = $MarginContainer/Price

@onready var label: Label = $MarginContainer/Label
@onready var line_2d: Line2D = $Line2D
@export var root = [0]
@export var unlocked = false
@export var price = 0
@onready var list = get_parent().get_children()

const skillButtonIcon := preload("res://skill_placeholder.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.set_texture(skillButtonIcon)
	price_label.text= str(price) + "$"
	for i in range(list.size()):
		if i in root:
			print (i,"radacina nod")
			line_2d.add_point(global_position + size/2)
			line_2d.add_point(list[i].global_position + size/2)

#var level: int = 0:
	#set(value):
		#level = value
		#label.text = str(level) + "/3"


func _on_pressed() -> void:
	if unlocked == false:
		if Globals.funds < price:
			color_rect.color = Color(0.769, 0.0, 0.0, 0.392)
		else :
			color_rect.color = Color(0.0, 1.0, 0.0, 0.392)
			color_rect.show_behind_parent = true
			line_2d.default_color = Color(0.0, 1.0, 0.0, 1.0)
			unlocked = true
			Globals.funds -= price
			print (unlocked)
			print (get_index())
			for skill in list:
				if get_index() in skill.root:
					print (skill.root)
					var all_unlocked = true
					for r in skill.root:
						if not list[r].unlocked:
							all_unlocked = false
							break
					if all_unlocked:
						skill.disabled = false
