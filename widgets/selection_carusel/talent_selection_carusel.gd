extends Control

signal valueChanged

@onready var scroll_container = %ScrollContainer
@onready var object_container = %ObjectContainer
@onready var selection_marker = %SelectionMarker
@onready var titleNode = %Title

@export var title = ""
@export var initialValue : Resource


var objects = ResourceData.allPushResources

func _ready():
	titleNode.text = title
	_create_labels()
	await get_tree().create_timer(0.01).timeout
	_set_carusel_start()
	
	%PushSelection.pressed.connect(_set_objects.bind("push"))
	%LegSelection.pressed.connect(_set_objects.bind("leg"))
	%PullSelection.pressed.connect(_set_objects.bind("pull"))
	%CoreSelection.pressed.connect(_set_objects.bind("core"))

func _create_labels():
	var spacer = Label.new()
	spacer.custom_minimum_size.x = 120
	object_container.add_child(spacer)
	
	
	for talent in objects:
		var talentName =  talent.resource_path.get_file().trim_suffix('.tres')
		var label = Label.new()
		label.text = talentName.replace("_", " ")
		label.add_theme_font_size_override("font_size", 20)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		object_container.add_child(label)
		label.custom_minimum_size = Vector2(51, 70)
	
	var spacer2 = Label.new()
	spacer2.custom_minimum_size.x = 120
	object_container.add_child(spacer2)
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		var mousePosition = get_global_mouse_position()
		
		if not get_global_rect().has_point(mousePosition):
			var value = get_selected_value()
			
			if not value: value = initialValue
			
			valueChanged.emit(value)
			queue_free()

func _set_carusel_start():
	var startScroll = 0
	scroll_container.scroll_horizontal = startScroll
	_select_deselect_objects(object_container.get_children()[1])
	
func _on_scroll_container_scroll_ended():
	var scrollNumber = scroll_container.scroll_horizontal
	var spaceBetween = _get_space_between_scroll_objects()
	var scrollDivider = scrollNumber / spaceBetween 
	var scrollRemainder = scrollNumber % spaceBetween

	var tween = get_tree().create_tween()
	var newScrollValue
	
	if scrollRemainder >= 50: 
		newScrollValue = (scrollDivider + 1) * spaceBetween
	else:
		newScrollValue = scrollDivider * spaceBetween
	
	tween.tween_property(scroll_container, "scroll_horizontal", newScrollValue ,0.2)
	tween.tween_callback(_select_deselect_objects)

func _get_space_between_scroll_objects():
	var sectionWidth = object_container.get_theme_constant("separation")
	var objectWidth = object_container.get_children()[1].custom_minimum_size.x
	var spaceBetween : int = sectionWidth + objectWidth	

	return spaceBetween
	
func _select_deselect_objects(label = null):
	if objects.is_empty(): return
	var selectedValue = get_selected_value()
	var selectedText = selectedValue.get_talent_name()

	for uiNode in object_container.get_children():
		if uiNode.text == selectedText || uiNode == label:
			uiNode.add_theme_constant_override("outline_size",5)
		else:
			uiNode.add_theme_constant_override("outline_size",0)

func get_selected_value():
	var valuePosition = selection_marker.global_position
	
	for uiNode in object_container.get_children():
		if uiNode.get_global_rect().has_point(valuePosition):
			var index = object_container.get_children().find(uiNode)
			return objects[index - 1]

func _set_objects(category):
	if category == "push": objects = ResourceData.allPushResources
	else: objects = []
	
	_refresh_carusel()

func _refresh_carusel():
	for node in object_container.get_children():
		node.queue_free()
		
	_create_labels()
