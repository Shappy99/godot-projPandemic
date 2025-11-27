extends Label
@onready var research_funds: Label = $"."


func _process(delta: float) -> void:
	research_funds.text = str(Globals.funds)
