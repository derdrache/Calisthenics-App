extends Camera2D

const ZOOM_MOUSE_SPEED = 0.1
const ZOOM_TOUCH_SPEED = 0.1
const MAX_ZOOM = 6
const MIN_ZOOM = 0.5

var touches: Dictionary = {}
var lastDragDistance := 0.0
var zoomStart := false


func _input(event: InputEvent) -> void:
			
	_handle_screen_touch(event)
	
	_handle_screen_drag(event)	
			
	_handle_mouse_zoom(event)

func _handle_screen_touch(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touches[event.index] = event.position
		else:
			touches.erase(event.index)
			zoomStart = false
		
func _handle_screen_drag(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		touches[event.index] = event.position
			
		if touches.size() == 1:
			global_position -= event.relative * 1.3 / zoom.x
		elif touches.size() == 2:
			var touchPositions := touches.values()
			var currentDistance: float = touchPositions[0].distance_to(touchPositions[1])
			var zoomDirection := clampf(ceil(currentDistance - lastDragDistance), -1.0, 1.0)
			
			if not zoomDirection: 
				return

			var midPoint : Vector2 = (touchPositions[0] + touchPositions[1]) / 2.0
			var worldMidPoint: Vector2 = get_canvas_transform().affine_inverse() * midPoint

			if not zoomStart:
				zoomStart = true
				global_position = worldMidPoint
			
			_change_zoom(zoomDirection * ZOOM_TOUCH_SPEED)
			global_position -= get_canvas_transform().affine_inverse() * midPoint - worldMidPoint
			lastDragDistance = currentDistance

func _handle_mouse_zoom(event: InputEvent) -> void:
	var last_global_mouse := get_global_mouse_position()
	var zoomDirection := Input.get_axis("mouseWheelDown", "mouseWheelUp")
	
	if not zoomDirection: 
		return
	
	if not zoomStart:
		zoomStart = true
		global_position = event.position
		
	_change_zoom(zoomDirection * ZOOM_MOUSE_SPEED)
	global_position += last_global_mouse - get_global_mouse_position()
		
func _change_zoom(value:float) -> void:
	var newZoom := zoom + Vector2.ONE * value
	zoom = newZoom.clamp(Vector2.ONE * MIN_ZOOM, Vector2.ONE * MAX_ZOOM)
	
