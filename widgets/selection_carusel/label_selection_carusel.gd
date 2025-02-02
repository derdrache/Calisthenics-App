extends Control
class_name LabelSelectionCarusel

signal valueChanged(value: String)

@onready var background_panel: PanelContainer = %BackgroundPanel
@onready var titleLabel: Label = %Title
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var object_container: HBoxContainer = %ObjectContainer
@onready var selection_marker: Control = %SelectionMarker

@export var title := ""
@export var stringList: Array
@export var maxValue := 10
@export var steps := 1
@export var initialValue := 5
@export var withBackground := true
@export var withCloseOnBackgroundClick := true

func _ready() -> void:
	titleLabel.text = title
	
	if stringList.is_empty():
		_create_number_labels()
	else:
		_create_normal_labels()
		
	await get_tree().create_timer(0.04).timeout
	
	_set_carusel_start()
	
	
	if not withBackground: _remove_background()

func _create_number_labels() -> void:
	var spacer := Label.new()
	
	spacer.custom_minimum_size.x = 70
	object_container.add_child(spacer)
	
	for i in maxValue / steps:
		var label := Label.new()
		label.text = str((i + 1) * steps)
		label.add_theme_font_size_override("font_size", 30)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		object_container.add_child(label)
		label.custom_minimum_size.x = 51
	
	var spacer2 := Label.new()
	spacer2.custom_minimum_size.x = 70
	object_container.add_child(spacer2)

func _create_normal_labels() -> void:
	var spacer := Label.new()
	spacer.custom_minimum_size.x = 60
	object_container.add_child(spacer)
	
	for i in len(stringList):
		var label := Label.new()
		label.text = stringList[i]
		label.add_theme_font_size_override("font_size", 20)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		object_container.add_child(label)
		label.custom_minimum_size.x = 80
	
	var spacer2 := Label.new()
	spacer2.custom_minimum_size.x = 60
	object_container.add_child(spacer2)

func  _remove_background() -> void:
	background_panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	
func _input(event: InputEvent) -> void:
	if not withCloseOnBackgroundClick: return
	var onContainer: bool = background_panel.get_global_rect().has_point(get_global_mouse_position())

	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed() and not onContainer:
		var value := get_selected_value()
		valueChanged.emit(value)

		queue_free()

func _set_carusel_start() -> void:
	var initalValueIndex := get_node_index(initialValue)
	var startScroll := _get_space_between_scroll_objects() * (initalValueIndex-1)
	scroll_container.scroll_horizontal = startScroll
	_select_deselect_objects(object_container.get_children()[initalValueIndex])

func get_node_index(value: int) -> int:
	for i in object_container.get_child_count():
		var object : Label = object_container.get_children()[i]
		if object.text == str(value):
			return i
	
	return -1

func _on_scroll_container_scroll_ended() -> void:
	var scrollNumber := scroll_container.scroll_horizontal
	var spaceBetween := _get_space_between_scroll_objects()
	var scrollDivider := scrollNumber / spaceBetween 
	var scrollRemainder := scrollNumber % spaceBetween

	var tween := get_tree().create_tween()
	var newScrollValue: int
	
	if scrollRemainder >= 50: 
		newScrollValue = (scrollDivider + 1) * spaceBetween
	else:
		newScrollValue = scrollDivider * spaceBetween
	
	tween.tween_property(scroll_container, "scroll_horizontal", newScrollValue ,0.2)
	tween.tween_callback(_select_deselect_objects)

func _get_space_between_scroll_objects() -> int:
	var sectionWidth : int = object_container.get_theme_constant("separation")
	var objectWidth: int = object_container.get_children()[1].custom_minimum_size.x
	var spaceBetween : int = sectionWidth + objectWidth	

	return spaceBetween

func _select_deselect_objects(label: Label = null) -> void:
	var selectedValue := get_selected_value()
	
	for uiNode: Label in object_container.get_children():
		if uiNode.text == str(selectedValue) || uiNode == label:
			uiNode.add_theme_constant_override("outline_size",5)
			uiNode.add_theme_color_override("font_color", Color(0,0,0))
			uiNode.add_theme_color_override("font_outline_color", Color(1,1,1))
		else:
			uiNode.add_theme_constant_override("outline_size",0)
			uiNode.add_theme_color_override("font_color", Color(1,1,1))
			uiNode.add_theme_color_override("font_outline_color", Color(0,0,0))

func get_selected_value() -> String:
	var valuePosition := selection_marker.global_position
	
	for uiNode: Label in object_container.get_children():
		if uiNode.get_global_rect().has_point(valuePosition):
			return uiNode.text

	return ""
