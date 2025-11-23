extends Node2D

@export var size := Vector2(3,3) * 10.0
@export var color := Color(1.0, 1.0, 0.0, 0.5)
@export var color2 := Color(1.0, 0.0, 0.0, 1.0)
func _draw():
	#momentan sunt hardcoded valorile, trebuie vazut la resize daca arata ok
	#polygon-ul porneste de la muchia p0 a patratului din interiorul hexagonului
	#p5 muchia exterioara stanga a hexagonului
	var pt0 = Vector2(-14,23)
	var pt1 = Vector2(14,23)
	var pt2 = Vector2(26,0)
	var pt3 = Vector2(14,-23)
	var pt4 = Vector2(-14,-23)
	var pt5 = Vector2(-26,0)
	var array = PackedVector2Array([pt0,pt1,pt2,pt3,pt4,pt5])
	draw_polygon(array,[color2])
	draw_rect(Rect2(-size / 2.0, size), color)
