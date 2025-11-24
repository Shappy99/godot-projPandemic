extends Camera2D

@export var zoomSpeed : float = 10

var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging: bool = false
var zoomTarget: Vector2

const minZoom: Vector2 = Vector2(1.0,1.0)
const maxZoom: Vector2 = Vector2(2.0,2.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoomTarget = zoom # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	Zoom(delta)
	ClickAndDrag()

func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("camera_pan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
		
	if isDragging and Input.is_action_just_released("camera_pan"):
		isDragging = false
	
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * 1/zoom.x

func Zoom(delta):
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoomTarget *= 1.1
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoomTarget *= 0.9
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)
	zoom = clamp(zoom,minZoom,maxZoom)
